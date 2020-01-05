#!/bin/bash

################################################################################################################################################################

# @project        Open Space Toolkit
# @file           tools/ci/documentation.sh
# @author         Lucas Brémond <lucas.bremond@gmail.com>
# @license        Apache License 2.0

################################################################################################################################################################

# https://gist.github.com/vidavidorra/548ffbcdae99d752da02

script_directory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

project_directory="${script_directory}/../.."

source "${project_directory}/tools/.env"

# Generate documentation

docker run \
--rm \
--volume="${project_directory}:/app:rw" \
--volume="/app/build" \
--workdir="/app/build" \
${image_name}:${image_version} \
/bin/bash -c "cmake -DBUILD_DOCUMENTATION=ON .. && make docs"

# Deploy documentation

mkdir -p "./gh-pages"

pushd "./gh-pages" > /dev/null

git clone -b gh-pages https://git@${ci_doc_repo_ref}

pushd ${ci_doc_repo_name} > /dev/null

# Set the push default to simple i.e. push only the current branch.

git config --global push.default simple

# Pretend to be an user called Travis CI.

git config user.name ${ci_doc_repo_user_name}
git config user.email ${ci_doc_repo_user_email}

rm -rf ./*
mv .git git
rm -rf ./.*
mv git .git

cp "${project_directory}"/README.md .
cp -r "${project_directory}"/docs/* .

# Need to create a .nojekyll file to allow filenames starting with an underscore
# to be seen on the gh-pages site. Therefore creating an empty .nojekyll file.
# Presumably this is only needed when the SHORT_NAMES option in Doxygen is set
# to NO, which it is by default. So creating the file just in case.

echo "" > .nojekyll

# Only upload if Doxygen successfully created the documentation.
# Check this by verifying that the html directory and the file html/index.html
# both exist. This is a good indication that Doxygen did its work.

if [ -d "html" ] && [ -f "html/index.html" ]; then

    # Add everything in this directory (the Doxygen code documentation) to the gh-pages branch.
    # GitHub is smart enough to know which files have changed and which files have
    # stayed the same and will only update the changed files.

    echo 'Adding documentation to the gh-pages branch...'

    git add --all

    # Commit the added files with a title and description containing the Travis CI
    # build number and the GitHub commit reference that issued this build.

    git commit -m "[feature] Deploy documentation to GitHub Pages" -m "Travis build: ${TRAVIS_BUILD_NUMBER}" -m "Commit: ${TRAVIS_COMMIT}"

    # Force push to the remote gh-pages branch.
    # The ouput is redirected to /dev/null to hide any sensitive credential data that might otherwise be exposed.

    echo 'Pushing documentation to remote...'

    git push --force "https://${ci_doc_repo_token}@${ci_doc_repo_ref}" > /dev/null 2>&1

else

    echo '' >&2
    echo '[Error] No documentation (html) files have been found!' >&2

    exit 1

fi

popd > /dev/null

################################################################################################################################################################
