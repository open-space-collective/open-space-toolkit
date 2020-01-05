#!/bin/bash

################################################################################################################################################################

# @project        Open Space Toolkit
# @file           tools/ci/binaries.sh
# @author         Lucas Brémond <lucas.bremond@gmail.com>
# @license        Apache License 2.0

################################################################################################################################################################

script_directory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

project_directory="${script_directory}/../.."
development_directory="${project_directory}/tools/development"

source "${project_directory}/tools/.env"

# Generate binaries

docker run \
--rm \
--volume="${project_directory}:/app:rw" \
--volume="${development_directory}/helpers/build.sh:/app/build/build.sh:ro" \
--volume="${development_directory}/helpers/test.sh:/app/build/test.sh:ro" \
--workdir="/app/build" \
${image_name}:${image_version} \
/bin/bash -c "/app/build/build.sh && make package && mkdir -p /app/package && mv /app/build/*.rpm /app/package"

################################################################################################################################################################
