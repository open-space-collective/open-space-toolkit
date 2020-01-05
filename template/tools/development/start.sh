#!/bin/bash

################################################################################################################################################################

# @project        Open Space Toolkit
# @file           tools/development/start.sh
# @author         Lucas Brémond <lucas.bremond@gmail.com>
# @license        Apache License 2.0

################################################################################################################################################################

script_directory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Setup environment

source "${script_directory}/../.env"

# Build Docker image if it does not exist already

if [[ "$(docker images -q ${image_name}:${image_version} 2> /dev/null)" == "" ]]; then

    pushd "${script_directory}/docker" > /dev/null

    ./build.sh

    popd > /dev/null

fi

# Run Docker container

docker run \
--name="${container_name}" \
-it \
--rm \
--privileged \
--volume="${project_directory}:/app:rw" \
--volume="${script_directory}/helpers/build.sh:/app/build/build.sh:ro,delegated" \
--volume="${script_directory}/helpers/test.sh:/app/build/test.sh:ro,delegated" \
--volume="${script_directory}/helpers/debug.sh:/app/build/debug.sh:ro,delegated" \
--volume="${script_directory}/helpers/clean.sh:/app/build/clean.sh:ro,delegated" \
--workdir="/app/build" \
"${image_name}:${image_version}" \
"/bin/bash"

################################################################################################################################################################
