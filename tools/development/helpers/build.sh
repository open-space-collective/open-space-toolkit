#!/usr/bin/env bash

# Apache License 2.0

project_directory="$(git rev-parse --show-toplevel)"
build_directory="${project_directory}/build"

mkdir -p "${build_directory}"

pushd "${build_directory}" > /dev/null

if [[ ! -z $1 ]] && [[ $1 == "--debug" ]]; then

    cmake -DCMAKE_BUILD_TYPE=Debug ..

else

    cmake ..

fi

make -j $(nproc)

popd > /dev/null
