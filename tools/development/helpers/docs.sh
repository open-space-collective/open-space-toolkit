#!/bin/bash

project_directory="$(git rev-parse --show-toplevel)"
docs_directory="${project_directory}/docs"

pushd "${docs_directory}" > /dev/null

help() {
    echo "Usage: ./docs.sh [--notebooks PROJECT_NAME]"
    echo "Generate documentation for the project."
    echo ""
    echo "Options:"
    echo "  --notebooks PROJECT_NAME   Generate documentation for notebooks of the specified project."
}

if [[ $1 == "--help" ]]; then
    help
    exit 0
fi

pip install -r requirements.txt

if [[ ! -z $1 ]] && [[ $1 == "--notebooks" ]]; then
    if [[ -z $2 ]]; then
        echo "Error: PROJECT_NAME is required when using --notebooks option."
        exit 1
    fi

    project_name_camel_case="$2"

    mkdir -p _notebooks
    cd _notebooks
    git init
    if ! git remote | grep -q "origin"; then
        git remote add origin https://github.com/open-space-collective/open-space-toolkit
        git config core.sparseCheckout true
        echo "notebooks/${project_name_camel_case}/*" >> .git/info/sparse-checkout
        git pull origin main
        find . -type f -name "*.ipynb" -exec mv {} . \;
    fi
    cd ..
fi

breathe-apidoc -o cpp_rst xml -g class

sphinx-build -j $(nproc) -b html . _build/html

popd > /dev/null
