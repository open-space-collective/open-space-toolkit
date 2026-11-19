---
name: ostk-dev-container-build-format-test
description: Build, test, and format any Open Space Toolkit (OSTk) repo (open-space-toolkit-core, -io, -mathematics, -physics, -astrodynamics, -simulation, ...) inside its dev container, fixing failures until everything passes. Use whenever the user is in an OSTk repo and asks to build, compile, format, or run the C++/Python tests, to check that a change or branch passes, or to run only the tests affected by their diff, or mentions ostk-build, ostk-test, or make dev, even if they don't say "dev container".
---

# OSTk dev container build, format, and test

This skill is explicit permission to start or enter the dev container, run the build and tests, and edit code to fix failures. Iterate on failures until the commands pass, within the limits in [Fixing failures](#fixing-failures).

Applies to any `open-space-toolkit-<project_name>` repo. All of them share the same `Makefile` structure.

## Instructions

1. Get a dev container (see [Start the container](#start-the-container)); don't run `make dev` itself
2. Compile with `ostk-build` and fix any compilation errors
3. Run the C++ unit tests with `ostk-test` and fix any issues
4. Run the Python unit tests with `ostk-test-python` and fix any issues
5. Format the code with `ostk-format-cpp` and `ostk-format-python`
6. Stop the container if you started it, and report what you did

Formatting comes after the tests so that the fixes made in steps 2 to 4 get formatted too. Formatting doesn't change behavior, so there's no need to rebuild or re-test after it.

## Agent notes

`make dev` (repo root `Makefile`) builds the `non-root` dev image, then runs an **interactive**, `--rm` container with `/bin/zsh`. An agent can't drive that shell, so start a detached container instead and `docker exec` into it.

### Resolve repo-specific values

From the repo root, derive the values used by the `Makefile`:

```bash
PROJECT_NAME="$(sed -nE 's/^project_name[[:space:]]*:?=[[:space:]]*//p' Makefile | head -n 1)"
IMAGE_VERSION="$(git describe --tags --always)"
CONTAINER="open-space-toolkit-${PROJECT_NAME}-dev-non-root"
AGENT_CONTAINER="${CONTAINER}-claude"
IMAGE="openspacecollective/open-space-toolkit-${PROJECT_NAME}-development-non-root:${IMAGE_VERSION}"
```

`CONTAINER` is the name `make dev` uses. `AGENT_CONTAINER` is the name for a container you start, so it never blocks the user from running `make dev`, and so it's always clear which container is yours to stop.

These values copy the `Makefile`'s naming. If the `make dev` step fails or the image isn't found, compare them with what the `Makefile` actually runs: `make -n dev | grep -A10 'docker run'` prints the commands without executing them.

Shell state may not persist between tool calls. If it doesn't, re-define these variables (or inline them) in each command.

### Start the container

1. Check for a running container. `docker ps --filter name=` matches substrings, so anchor the names:

```bash
docker ps --filter "name=^${CONTAINER}$" --format '{{.Names}}'
docker ps --filter "name=^${AGENT_CONTAINER}$" --format '{{.Names}}'
```

- If the user's `${CONTAINER}` is running (they have a `make dev` session open), use it. Don't start a second container, because both would write to the same `build/` directory. Never stop the user's container.
- If `${AGENT_CONTAINER}` is running from an earlier session, reuse it.
- Otherwise, start one as in step 2.

2. Build the image and start a detached container with the same mounts as `make dev`:

```bash
make build-development-image-non-root

mkdir -p build

docker run \
  --name="${AGENT_CONTAINER}" \
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

The first image build can take several minutes, so use a long timeout. If `~/.gitconfig` doesn't exist on the host, drop that mount; Docker would otherwise create a directory in its place.

In the commands below, `${C}` means whichever container you're using, either `${CONTAINER}` or `${AGENT_CONTAINER}`.

3. Pick the shell once. The `ostk-*` commands may be scripts on `PATH` or zsh functions:

```bash
docker exec "${C}" bash -c 'command -v ostk-build'   # if this prints a path, use bash -c
docker exec "${C}" zsh -ic 'whence ostk-build'       # otherwise use zsh -ic, which loads the shell environment
```

Use the shell that works for every command after this. The examples below use `bash -c`.

4. Run each command with:

```bash
docker exec --workdir=/app/build "${C}" bash -c "<command>"
```

### Long-running commands

The build and full test suites can run longer than a single tool call allows. Run them in the background with a log and an exit-code file, then poll:

```bash
docker exec "${C}" rm -f /tmp/ostk-build.rc
docker exec --detach --workdir=/app/build "${C}" bash -c \
  'ostk-build > /tmp/ostk-build.log 2>&1; echo $? > /tmp/ostk-build.rc'

# poll until the exit code appears
docker exec "${C}" sh -c 'cat /tmp/ostk-build.rc 2>/dev/null || tail -n 3 /tmp/ostk-build.log'
```

Remove the old `.rc` file first, as shown, so a previous run's exit code isn't mistaken for this one's.

Build and test output is huge, so don't read whole logs. Pull out the failures instead:

```bash
docker exec "${C}" grep -nE 'error:|undefined reference|\[  FAILED  \]|^FAILED |^E   |Traceback' /tmp/ostk-build.log | head -n 60
```

### Commands, in order

Build:

```bash
ostk-build
```

If `/app/build/CMakeCache.txt` doesn't exist, run `cmake ..` from `/app/build` first. `build/` is shared with the host. Errors about compiler paths or CMake versions that have nothing to do with the code usually mean a cache from a different image. Tell the user and ask before clearing `build/`, since it may hold a long build of theirs.

Test:

By default, run everything:

```bash
ostk-test
ostk-test-python
```

If the user specifies a test filter or a subset of tests (or asks to run only the tests affected by the diff), see [Running a subset of tests](#running-a-subset-of-tests).

`ostk-test-python` runs against the compiled bindings, so re-run `ostk-build` after any C++ or binding change before re-running the Python tests.

Format (last, after the tests pass):

```bash
git status --porcelain > /tmp/ostk-pre-format.txt   # on the host
ostk-format-cpp
ostk-format-python
git status --porcelain                              # on the host
```

Compare the two `git status` outputs. A file that was clean before and is modified now is formatter drift, usually from a formatter version that differs from the one the repo was last formatted with. Restore those files with `git checkout -- <files>`; they had no changes of the user's, so nothing is lost. Mention this in the report. Skip this check if the user asked to format the whole repo.

### Running a subset of tests

Only do this when the user asks for it; otherwise run the full suites.

**C++**: `ostk-test` runs `./bin/*.test --gtest_filter=<first arg>` from the repo root. Pass a single, quoted gtest filter; separate multiple patterns with `:`:

```bash
ostk-test 'OpenSpaceToolkit_Astrodynamics_Access_Generator.*:OpenSpaceToolkit_Astrodynamics_Access_AccessTarget.*'
```

Test suite names are the first argument of `TEST`/`TEST_F`/`TEST_P` in each `*.test.cpp` file. One file can contain several suites, so read them from the file rather than guessing from the file path:

```bash
rg -o --no-filename '^\s*TEST(_F|_P)?\s*\(\s*\w+' <file>.test.cpp | sed -E 's/.*\(\s*//' | sort -u
```

`TEST_P` tests are named `<Instantiation>/<Suite>.<Test>/<index>`, so for a `TEST_P` suite add `*/<Suite>.*` alongside `<Suite>.*`.

**Python**: `ostk-test-python` runs `uv run pytest -sv "$@"` from `/app/build/bindings/python/OpenSpaceToolkit*Py-python-package-${OSTK_PYTHON_VERSION}`. That directory has a copy of `bindings/python/test` at `test/`, so pass paths relative to it (drop the `bindings/python/` prefix). Any pytest args work (`::test_name`, `-k`, ...):

```bash
ostk-test-python test/access/test_generator.py test/test_trajectory.py::TestTrajectory
```

The tests are copied into the package only when the bindings get rebuilt. If you changed Python test files without rebuilding, sync them before running. Replace the directory rather than copying over it, so deleted or renamed tests don't linger:

```bash
PKG=$(echo /app/build/bindings/python/OpenSpaceToolkit*Py-python-package-${OSTK_PYTHON_VERSION})
rm -rf "${PKG}/test" && cp -r /app/bindings/python/test "${PKG}/test"
```

**Only the tests in the diff**: when the user asks for this, work out the changed files from the repo root on the host. That means changes on the branch, uncommitted changes, and untracked files. `--diff-filter=d` leaves out deleted files, which have no tests left to run:

```bash
BASE="$(git merge-base HEAD origin/main)"
{ git diff --name-only --diff-filter=d "${BASE}"; git ls-files --others --exclude-standard; } | sort -u
```

`origin/main` is whatever was last fetched; if it looks stale, say so. If the user names a different base (e.g. "only my uncommitted changes" means `git diff --name-only --diff-filter=d HEAD`), use that instead. Then map the changed files to tests:

- Changed `test/**/*.test.cpp`: run the suites in that file (see the `rg` command above).
- Changed C++ source/header with no test change (`src/OpenSpaceToolkit/<Path>/<Name>.cpp`, `include/OpenSpaceToolkit/<Path>/<Name>.hpp`): run the suites in the matching `test/OpenSpaceToolkit/<Path>/<Name>.test.cpp`, if it exists.
- Changed `bindings/python/test/**/test_*.py`: run that file.
- Changed binding source with no test change (`bindings/python/src/OpenSpaceToolkit<Project>Py/<Path>/<Name>.cpp*`): look for the matching `bindings/python/test/<path>/test_<name>.py` (snake_case). Converting names is error-prone with acronyms (`TLE`, `COE`), so if that file doesn't exist, search for the class name instead: `rg -lw '<Name>' bindings/python/test`.
- If a change has no clear matching test (e.g. CMake, shared headers or utilities, `conftest.py`, data), say so and ask the user whether to run the full suite.

Build all the filters first, then run `ostk-test '<filter>'` once and `ostk-test-python <paths...>` once. Skip a command if nothing maps to it. Tell the user which tests you ran.

### Fixing failures

After each failure: fix the code, re-run `ostk-build` if C++ or bindings changed, then re-run only the tests that failed. Once they pass, re-run the original command once more to confirm. Do not skip steps or treat failures as done.

Keep the fixes honest:

- **Fix the code under test, not the test.** Don't delete, skip, or xfail tests, loosen tolerances, or change expected values, unless the user's change intentionally altered that behavior. If you're not sure, ask. A test edited until it passes hides the bug it was there to catch.
- **Environment failures are not code bugs.** Network errors, failed data downloads (some OSTk physics and astrodynamics tests fetch data files at runtime), missing credentials, a full disk, or a killed process: report them; don't change code to work around them.
- **Failures unrelated to the change may already exist on main.** If a failing test has nothing to do with what changed, report it rather than fixing it as a side quest, unless the user asks.
- **Stop after three attempts at the same failure.** Report what you tried and what you think is wrong. More guessing usually makes the diff worse.

### Finishing

If you started `${AGENT_CONTAINER}`, stop it, even if you stopped early: `docker stop "${AGENT_CONTAINER}"`. Never stop `${CONTAINER}`; it belongs to the user's `make dev` session.

End with a short report:

- **What ran:** build, C++ tests (filter or "full"), Python tests (paths or "full"), formatting.
- **Results:** pass/fail counts per suite. For anything still failing, the test name and a one-line cause.
- **What you changed:** fixes with a one-line reason per file, listed separately from format-only changes and any formatter drift you restored.
- **What's left for the user:** unmapped files, environment failures, pre-existing failures, and whether the container was stopped or left running.
