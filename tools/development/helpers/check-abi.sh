#!/usr/bin/env bash

# Apache License 2.0

# Check that the shared library of the current OSTk project at <new-revision> is binary and source compatible with the
# one at <old-revision>.
#
# Each revision is built with debug info in its own local clone, its ABI is dumped with abi-dumper (restricted to the
# public headers in include/), and the two dumps are compared with abi-compliance-checker.
#
# Usage: ostk-check-abi [<old-revision> [<new-revision>]]    (defaults: the latest tag, and HEAD)
#
# Only committed changes are checked. The HTML report is written to <project>/build/abi-report/.
#
# The old revision is built in the same environment as the new one, so it cannot be built if it requires a major version
# of an OSTk dependency that the new revision does not. Such a bump is itself a break of the library, so the
# revisions are reported as not comparable instead of failing the build of the old revision.
#
# Exit status: 0 if compatible, 1 if incompatible, 3 if not comparable (an OSTk dependency of the old revision changed major version or was removed),
# 2 on any other error, including those reported by the tools it runs.

set -Eeuo pipefail

# Exit status 1 means incompatible, so any unexpected failure must exit with 2 instead.
trap 'exit 2' ERR

project_directory="$(git rev-parse --show-toplevel)"
report_directory="${project_directory}/build/abi-report"

old_revision="${1:-$(git -C "${project_directory}" describe --tags --abbrev=0)}"
new_revision="${2:-HEAD}"

library_name="$(git -C "${project_directory}" show "${new_revision}:CMakeLists.txt" | sed -n 's/^SET (PROJECT_PACKAGE_NAME "\(.*\)")$/\1/p')"

if [[ -z "${library_name}" ]]; then
    echo "Error: PROJECT_PACKAGE_NAME not found in the CMakeLists.txt of ${new_revision}." >&2
    exit 2
fi

# Lists the required major version of each OSTk dependency, e.g. "OpenSpaceToolkitCore 5".
dependency_majors () {

    git -C "${project_directory}" show "$1:CMakeLists.txt" \
        | sed -nE 's/^[[:space:]]*FIND_PACKAGE[[:space:]]*\([[:space:]]*"(OpenSpaceToolkit[A-Za-z]*)"[[:space:]]+"([0-9]+)[^"]*".*/\1 \2/Ip' \
        | sort -u

}

old_dependencies="$(dependency_majors "${old_revision}")"
new_dependencies="$(dependency_majors "${new_revision}")"

# Only the dependencies required by the old revision matter: it is the one that must be built in this environment.
# Dependencies that only the new revision requires do not prevent building the old one.
unmatched_dependencies="$(comm -23 <(echo "${old_dependencies}") <(echo "${new_dependencies}"))"

if [[ -n "${unmatched_dependencies}" ]]; then
    echo "Not comparable: ${old_revision} requires OSTk dependencies that ${new_revision} requires at another major version, or no longer requires:" >&2
    while read -r name major; do
        new_major="$(awk -v name="${name}" '$1 == name { print $2 }' <<< "${new_dependencies}")"
        echo "  ${name}: ${major} -> ${new_major:-removed}" >&2
    done <<< "${unmatched_dependencies}"
    echo "The old revision cannot be built against the dependencies installed for the new one." >&2
    exit 3
fi

# vtable-dumper treats any argument containing "-h" or "-v" as --help or --version, so this path must contain neither.
work_directory="/tmp/ostk-abi-check"

# The library builds do not need the Git LFS data files, and the local clones have no LFS objects to check out.
export GIT_LFS_SKIP_SMUDGE=1

build_and_dump () {

    local revision="$1"
    local name="$2"

    local source_directory="${work_directory}/${name}"
    local commit version library

    commit="$(git -C "${project_directory}" rev-parse --verify "${revision}^{commit}")"

    rm -rf "${source_directory}"
    git clone --quiet --shared --no-checkout "${project_directory}" "${source_directory}"
    git -C "${source_directory}" checkout --quiet --detach "${commit}"

    version="$(git -C "${source_directory}" describe --tags --always)"

    echo "Building ${library_name} at ${revision} (${version})..."

    if ! {
        cmake -S "${source_directory}" -B "${source_directory}/build" \
            -DCMAKE_BUILD_TYPE=Debug \
            -DCMAKE_CXX_FLAGS_DEBUG="-g -Og" \
            -DBUILD_UNIT_TESTS=OFF \
            -DBUILD_PYTHON_BINDINGS=OFF \
            -DBUILD_DOCUMENTATION=OFF \
        && cmake --build "${source_directory}/build" -j "$(nproc)"
    } > "${work_directory}/${name}-build.log" 2>&1; then
        tail -n 50 "${work_directory}/${name}-build.log"
        echo "Error: failed to build ${revision}." >&2
        exit 2
    fi

    library="$(find "${source_directory}/lib" -name "lib${library_name}.so.*" -type f -print -quit)"

    if [[ -z "${library}" ]]; then
        echo "Error: lib${library_name}.so not found after building ${revision}." >&2
        exit 2
    fi

    # abi-dumper does not report vtable-dumper failures: it silently records empty virtual tables.
    local exported_vtables dumped_vtables
    exported_vtables="$(nm -D --defined-only "${library}" | grep -c " _ZTV" || true)"
    dumped_vtables="$(vtable-dumper "${library}" | grep -c "^Vtable for" || true)"

    if [[ ${exported_vtables} -gt 0 && ${dumped_vtables} -eq 0 ]]; then
        echo "Error: vtable-dumper could not read the virtual tables of ${library}." >&2
        exit 2
    fi

    if ! abi-dumper "${library}" \
        -o "${work_directory}/${name}.dump" \
        -lver "${version}" \
        -public-headers "${source_directory}/include" \
        > "${work_directory}/${name}-dump.log" 2>&1; then
        cat "${work_directory}/${name}-dump.log"
        echo "Error: failed to dump the ABI of ${revision}." >&2
        exit 2
    fi

}

mkdir -p "${work_directory}"
rm -rf "${report_directory}"

build_and_dump "${old_revision}" old
build_and_dump "${new_revision}" new

echo "Comparing ABIs..."

# abi-compliance-checker can loop forever on a malformed dump, so bound its run time.
status=0
(
    cd "${work_directory}"
    timeout 600 abi-compliance-checker \
        -l "${library_name}" \
        -old old.dump \
        -new new.dump \
        -report-path "${report_directory}/compat_report.html" \
        < /dev/null
) || status=$?

if [[ ${status} -eq 124 ]]; then
    echo "Error: abi-compliance-checker timed out." >&2
    exit 2
fi

# abi-compliance-checker exits with 0 if compatible, 1 if incompatible, and 2 or more on error, with its own meaning for
# each (e.g. 3 for a missing system command). The statuses 2 and above are the ones this script uses for its own
# errors and for not comparable revisions (3), so any checker error is reported as 2 to not be mistaken for them.
if [[ ${status} -gt 1 ]]; then
    echo "Error: abi-compliance-checker failed with status ${status}." >&2
    exit 2
fi

exit ${status}
