#!/bin/bash

################################################################################################################################################################

# @project        Libraries
# @file           tools/development/docker/build.sh
# @author         Lucas Brémond <lucas@loftorbital.com>
# @license        TBD

################################################################################################################################################################

script_directory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Setup environment

source "${script_directory}/../../.env"

# Build Docker image

docker build \
--build-arg="version=${version}" \
--build-arg="cpu_count=${cpu_count}" \
--tag="${image_name}" \
--file="${script_directory}/Dockerfile" \
"${script_directory}"

################################################################################################################################################################