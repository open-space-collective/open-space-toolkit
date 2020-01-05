#!/bin/bash

################################################################################################################################################################

# @project        Open Space Toolkit
# @file           tools/development/helpers/build.sh
# @author         Lucas Brémond <lucas.bremond@gmail.com>
# @license        Apache License 2.0

################################################################################################################################################################

project_directory="$(git rev-parse --show-toplevel)"
build_directory="${project_directory}/build"

pushd "${build_directory}" > /dev/null

if [[ ! -z $1 ]] && [[ $1 == "--debug" ]]; then

    cmake -DCMAKE_BUILD_TYPE=Debug ..

else

    cmake ..

fi

make -j $(nproc)

popd > /dev/null

################################################################################################################################################################
