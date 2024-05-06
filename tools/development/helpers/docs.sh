#!/bin/bash

project_directory="$(git rev-parse --show-toplevel)"
project_name_camel_case=$(echo "$project_directory" | cut -d '-' -f4- | sed -r 's/(^|-)([a-z])/\U\2/g')
docs_directory="${project_directory}/docs"

pushd "${docs_directory}" > /dev/null

pip install -r requirements.txt

if [[ ! -z $1 ]] && [[ $1 == "--notebooks" ]]; then

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
