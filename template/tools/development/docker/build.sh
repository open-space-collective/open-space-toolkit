#!/bin/bash

################################################################################################################################################################

# @project        Libraries
# @file           tools/development/docker/build.sh
# @author         Lucas Brémond <lucas.bremond@gmail.com>
# @license        Apache License 2.0

################################################################################################################################################################

script_directory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Setup environment

source "${script_directory}/../../.env"

# Build Docker image

docker build \
--build-arg="VERSION=${image_version}" \
--tag="${image_name}:${image_version}" \
--file="${script_directory}/Dockerfile" \
"${script_directory}"

# Tag Docker image

docker tag "${image_name}:${image_version}" "${image_name}:latest"

################################################################################################################################################################
