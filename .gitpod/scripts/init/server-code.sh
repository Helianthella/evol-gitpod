#!/bin/bash

# git setup
git clone https://gitlab.com/evol/hercules.git --origin upstream server-code
pushd server-code
if [[ ! -z "$GITLAB_NAME" ]]; then
    git remote add origin "https://gitlab.com/$GITLAB_NAME/hercules.git"
fi

# we also add 2 remotes for direct contributions to Hercules:
git remote add herc "https://github.com/HerculesWS/Hercules.git"
if [[ ! -z "$GITHUB_NAME" ]]; then
    git remote add hub "https://github.com/$GITHUB_NAME/Hercules.git"
fi

git clone https://gitlab.com/evol/evol-hercules.git --origin upstream src/evol
pushd src/evol
if [[ ! -z "$GITLAB_NAME" ]]; then
    git remote add origin "https://gitlab.com/$GITLAB_NAME/evol-hercules.git"
fi

popd
popd
ln -s server-code/src/evol server-plugin
