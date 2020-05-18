#!/bin/bash

# git setup
git clone https://gitlab.com/evol/evol-tools.git --origin upstream tools
pushd tools
if [[ ! -z "$GITLAB_NAME" ]]; then
    git remote add origin "https://gitlab.com/$GITLAB_NAME/evol-tools.git"
fi

popd
