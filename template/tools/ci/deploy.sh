#!/bin/bash

################################################################################################################################################################

# @project        Open Space Toolkit
# @file           tools/ci/deploy.sh
# @author         Lucas Brémond <lucas.bremond@gmail.com>
# @license        Apache License 2.0

################################################################################################################################################################

script_directory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

project_directory="${script_directory}/../.."
development_directory="${project_directory}/tools/development"

source "${project_directory}/tools/.env"

# Deploy Python bindings

docker run \
--rm \
--volume="${project_directory}:/app:rw" \
--volume="${development_directory}/helpers/build.sh:/app/build/build.sh:ro" \
--volume="${development_directory}/helpers/test.sh:/app/build/test.sh:ro" \
--workdir="/app/build" \
--env="TWINE_USERNAME=${PYPI_USERNAME}" \
--env="TWINE_PASSWORD=${PYPI_PASSWORD}" \
${image_name}:${image_version} \
/bin/bash -c "make publish"

################################################################################################################################################################
