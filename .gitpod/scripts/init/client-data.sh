#!/bin/bash

# git setup
git clone https://gitlab.com/evol/clientdata.git --origin upstream client-data
pushd client-data
if [[ ! -z "$GITLAB_NAME" ]]; then
    git remote add origin "https://gitlab.com/$GITLAB_NAME/clientdata.git"
fi
popd
