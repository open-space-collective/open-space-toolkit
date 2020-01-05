#!/bin/bash

################################################################################################################################################################

# @project        Open Space Toolkit
# @file           tools/ci/coverage.sh
# @author         Lucas Brémond <lucas.bremond@gmail.com>
# @license        Apache License 2.0

################################################################################################################################################################

script_directory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

project_directory="${script_directory}/../.."

source "${project_directory}/tools/.env"

docker run \
--rm \
--volume="${project_directory}:/app:rw" \
--volume="/app/build" \
--workdir="/app/build" \
${image_name}:${image_version} \
/bin/bash -c "cmake -DBUILD_CODE_COVERAGE=ON .. && make coverage && bash <(curl -s https://codecov.io/bash) -X gcov -y /app/.codecov.yml -t ${ci_codecov_token} || echo 'Codecov did not collect coverage reports'"

################################################################################################################################################################
