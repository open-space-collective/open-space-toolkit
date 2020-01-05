#!/bin/bash

################################################################################################################################################################

# @project        Open Space Toolkit
# @file           tools/python/3.6/build.sh
# @author         Lucas Brémond <lucas.bremond@gmail.com>
# @license        Apache License 2.0

################################################################################################################################################################

set -a
set -e

script_directory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
project_directory="$(git rev-parse --show-toplevel)"

source "${script_directory}/.env"

pushd "${project_directory}" > /dev/null

docker build \
--tag="${image_repository}:${image_tag}" \
--file="${script_directory}/Dockerfile" \
.

popd > /dev/null

################################################################################################################################################################
