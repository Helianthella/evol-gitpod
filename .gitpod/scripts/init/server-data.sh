#!/bin/bash

# git setup
git clone https://gitlab.com/evol/serverdata.git --origin upstream server-data
pushd server-data
if [[ ! -z "$GITLAB_NAME" ]]; then
    git remote add origin "https://gitlab.com/$GITLAB_NAME/serverdata.git"
fi

# config
make config
# TODO: fine-tune the settings
make build

popd
