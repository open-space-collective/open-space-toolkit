#!/bin/bash

################################################################################################################################################################

# @project        Libraries
# @file           tools/development/start.sh
# @author         Lucas Brémond <lucas@loftorbital.com>
# @license        TBD

################################################################################################################################################################

script_directory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Setup environment

source "${script_directory}/../.env"

# Build Docker image if it does not exist already

if [[ "$(docker images -q ${image_name} 2> /dev/null)" == "" ]]; then

    pushd "${script_directory}/docker" > /dev/null

    ./build.sh

    popd

fi

# Run Docker container

docker run \
--name="${container_name}" \
-it \
--rm \
--privileged \
"${image_name}" \
"/bin/bash"

################################################################################################################################################################