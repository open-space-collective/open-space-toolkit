---
name: ostk-dev-container-build-format-test
description: Build, format, and test any Open Space Toolkit (OSTk) repo (core, io, mathematics, physics, astrodynamics, simulation, ...) inside its dev container, fixing failures until everything passes. Use when the user asks to build, format, and/or run the C++/Python tests of an OSTk repo.
---

# OSTk dev container build, format, and test

This skill is explicit permission to enter the dev container and run tests. Iterate on failures until the commands pass.

Applies to any `open-space-toolkit-<project_name>` repo. All of them share the same `Makefile` structure.

## Instructions

1. Start (or reuse) a dev container named after the current branch, from the repo root. See [Start the container non-interactively](#start-the-container-non-interactively)
2. Once inside (working directory `/app/build`), compile with `ostk-build` and fix any compilation errors
3. Format the code with `ostk-format-cpp` and `ostk-format-python`
4. Run the C++ unit tests with `ostk-test` and fix any issues
5. Run the Python unit tests with `ostk-test-python` and fix any issues

## Agent notes

`make dev` (repo root `Makefile`) builds the `non-root` dev image, then runs an **interactive**, `--rm` container with `/bin/zsh` under a fixed name. Do not hang on that shell, and don't use `make dev` to start containers: start them yourself as described below.

### Resolve repo-specific values

From the repo root, derive the values used by the `Makefile`:

```bash
PROJECT_NAME="$(sed -n 's/^project_name := //p' Makefile)"
IMAGE_VERSION="$(git describe --tags --always)"
BRANCH="$(git rev-parse --abbrev-ref HEAD)"
[ "${BRANCH}" = "HEAD" ] && BRANCH="$(git rev-parse --short HEAD)"
BRANCH_SLUG="$(printf '%s' "${BRANCH}" | tr -c 'a-zA-Z0-9_.-' '-' | cut -c1-60)"
CONTAINER="open-space-toolkit-${PROJECT_NAME}-dev-${BRANCH_SLUG}"
IMAGE="openspacecollective/open-space-toolkit-${PROJECT_NAME}-development-non-root:${IMAGE_VERSION}"
```

The container name includes the branch so that agents working in different workspaces at the same time each get their own container. Never use the `Makefile`'s fixed name (`open-space-toolkit-${PROJECT_NAME}-dev-non-root`) for a container you start.

Shell state may not persist between tool calls. If it doesn't, re-define these variables (or inline them) in each command.

### Start the container non-interactively

1. Check whether a container for this workspace is already running. Check both the branch container and the user's `make dev` container, and print each one's `/app` mount source:

```bash
for NAME in "${CONTAINER}" "open-space-toolkit-${PROJECT_NAME}-dev-non-root"; do
  docker inspect --format '{{.Name}} {{range .Mounts}}{{if eq .Destination "/app"}}{{.Source}}{{end}}{{end}}' "${NAME}" 2>/dev/null
done
```

Reuse a container only if its `/app` source is the current repo root (`$(pwd)`). If so, set `CONTAINER` to its name and skip to step 3. If the branch container exists but mounts a different directory (another workspace on the same branch), set `CONTAINER="${CONTAINER}-$(pwd | md5sum | cut -c1-8)"` and continue.

2. Otherwise, build the image and start a detached container with the same mounts as `make dev`:

```bash
make build-development-image-non-root

mkdir -p build

docker run \
  --name="${CONTAINER}" \
  --detach \
  --rm \
  --volume="$(pwd):/app:delegated" \
  --volume="/app/bindings/python/.venv" \
  --volume="$HOME/.ssh:/home/developer/.ssh:ro" \
  --volume="$HOME/.gitconfig:/home/developer/.gitconfig:ro" \
  --workdir=/app/build \
  "${IMAGE}" \
  sleep infinity
```

3. Exec each command into it:

```bash
docker exec --workdir=/app/build "${CONTAINER}" bash -c "<command>"
```

If an `ostk-*` command is not found with `bash -c`, retry with `zsh -ic "<command>"` so the shell environment is loaded.

### Commands, in order

Build (the first build can take a long time, so use a long timeout and run it in the background if needed):

```bash
ostk-build
```

If the build directory isn't configured yet, run `cmake ..` from `/app/build` first.

Format:

```bash
ostk-format-cpp
ostk-format-python
```

Test:

By default, run everything:

```bash
ostk-test
ostk-test-python
```

If the user specifies a test filter or a subset of tests (or asks to run only the tests affected by the diff), see [Running a subset of tests](#running-a-subset-of-tests).

`ostk-test-python` runs against the compiled bindings, so re-run `ostk-build` after any C++ or binding change before re-running the Python tests.

### Running a subset of tests

Only do this when the user asks for it; otherwise run the full suites.

**C++**: `ostk-test` runs `./bin/*.test --gtest_filter=<first arg>` from the repo root. Pass a single, quoted gtest filter; separate multiple patterns with `:`:

```bash
ostk-test 'OpenSpaceToolkit_Astrodynamics_Access_Generator.*:OpenSpaceToolkit_Astrodynamics_Access_AccessTarget.*'
```

Test suite names are the first argument of `TEST`/`TEST_F`/`TEST_P` in each `*.test.cpp` file. One file can contain several suites, so read them from the file rather than guessing from the file path:

```bash
rg -o --no-filename '^TEST(_F|_P)?\s*\(\s*\w+' <file>.test.cpp | sed -E 's/.*\(\s*//' | sort -u
```

**Python**: `ostk-test-python` runs `uv run pytest -sv "$@"` from `/app/build/bindings/python/OpenSpaceToolkit*Py-python-package-${OSTK_PYTHON_VERSION}`. That directory has a copy of `bindings/python/test` at `test/`, so pass paths relative to it (drop the `bindings/python/` prefix). Any pytest args work (`::test_name`, `-k`, ...):

```bash
ostk-test-python test/access/test_generator.py test/test_trajectory.py::TestTrajectory
```

The tests are copied into the package only when the bindings get rebuilt. If you only changed Python test files, sync them before running:

```bash
cp -r /app/bindings/python/test/. /app/build/bindings/python/OpenSpaceToolkit*Py-python-package-${OSTK_PYTHON_VERSION}/test/
```

**Only the tests in the diff**: when the user asks for this, work out the changed files from the repo root on the host. That means changes on the branch, uncommitted changes, and untracked files:

```bash
BASE="$(git merge-base HEAD origin/main)"
{ git diff --name-only "${BASE}"; git ls-files --others --exclude-standard; } | sort -u
```

If the user names a different base (e.g. "only my uncommitted changes" means `git diff --name-only HEAD`), use that instead. Then map the changed files to tests:

- Changed `test/**/*.test.cpp`: run the suites in that file (see the `rg` command above).
- Changed C++ source/header with no test change (`src/OpenSpaceToolkit/<Path>/<Name>.cpp`, `include/OpenSpaceToolkit/<Path>/<Name>.hpp`): run the suites in the matching `test/OpenSpaceToolkit/<Path>/<Name>.test.cpp`, if it exists.
- Changed `bindings/python/test/**/test_*.py`: run that file.
- Changed binding source with no test change (`bindings/python/src/OpenSpaceToolkit<Project>Py/<Path>/<Name>.cpp*`): run the matching `bindings/python/test/<path>/test_<name>.py` (snake_case), if it exists.
- If a change has no clear matching test (e.g. CMake, shared utilities, data), say so and ask the user whether to run the full suite.

Build all the filters first, then run `ostk-test '<filter>'` once and `ostk-test-python <paths...>` once. Skip a command if nothing maps to it. Tell the user which tests you ran.

After each failure: fix the code, re-run `ostk-build` if C++ or bindings changed, then re-run the command that failed. Do not skip steps or treat failures as done.

When finished, stop the detached container if you started it (don't stop a container the user started): `docker stop "${CONTAINER}"`.
