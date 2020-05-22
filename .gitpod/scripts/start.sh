#!/bin/bash

# script run every time the gitpod instance launches

set -e
echo "⌛  running startup script..."

function dirty_exit() {
    ret=$?

    if [ $ret -gt 0 ]; then
        echo
        echo "❌  an error occured when running command:"
        echo "$ ${BASH_COMMAND}"
    else
        exit 0
    fi
}

trap dirty_exit EXIT

chmod u+x ./.gitpod/**/*.sh

REPO_REMOTE=$(git config --get remote.origin.url)

if [ "${REPO_REMOTE:8:10}" = "gitlab.com" ]; then
    export GITLAB_NAME=$(git config --get remote.origin.url | sed -r "s#.+\.com[:/]{1,2}([^/]+)/.+#\1#")
elif [ "${REPO_REMOTE:8:10}" = "github.com" ]; then
    export GITHUB_NAME=$(git config --get remote.origin.url | sed -r "s#.+\.com[:/]{1,2}([^/]+)/.+#\1#")
fi

REPO_LIST=(
    tools
    server-code
    server-plugin
    server-data
    client-data
    manaplus
)

function git_pull() {
    local DIR="$1"
    local REMOTE="upstream"
    local BRANCH="master"
    local UPSTREAM="$REMOTE/$BRANCH"

    pushd $DIR 1>/dev/null
    git fetch -q $REMOTE

    local UPSTREAM_URL=$(git config --get remote.upstream.url)
    local FORK_URL=$(git config --get remote.origin.url 2>/dev/null || echo "")

    if [[ ! -z "$GITLAB_NAME" ]] && [ -z "$FORK_URL" ]; then
        FORK_URL=$(git config --get remote.upstream.url | sed -r "s%https://gitlab.com/([^/]+)/(.+(\.git)?)%https://gitlab.com/$GITLAB_NAME/\2%")
        git remote add --fetch origin "$FORK_URL" 1>/dev/null
    fi

    local CURRENT=$(git rev-parse --abbrev-ref --symbolic-full-name @{u})
    local CURRENT_BRANCH=$(git symbolic-ref --short HEAD)

    if [ "$CURRENT" = "$UPSTREAM" ] && [ "$CURRENT_BRANCH" = "$BRANCH" ]; then
        local LOCAL=$(git rev-parse @)
        #local REMOTE=$(git rev-parse "$UPSTREAM")
        local BASE=$(git merge-base @ "$UPSTREAM")

        if [ $LOCAL = $BASE ]; then
            # we are on upstream/master and can fast-forward
            git pull -q
        fi
    fi
    popd 1>/dev/null
}

for i in "${REPO_LIST[@]}"; do
    ln -sf ~/.evol/$i $i
    git_pull "$i" &
done; wait

# set up extra remotes for Hercules development
pushd server-code 1>/dev/null
HERC_FORK_URL=$(git config --get remote.hub.url 2>/dev/null || echo "")
if [[ ! -z "$GITHUB_NAME" ]] && [ -z "$HERC_FORK_URL" ]; then
    git remote add --fetch hub "https://github.com/$GITHUB_NAME/Hercules.git" &>/dev/null
fi
popd 1>/dev/null

./.gitpod/scripts/sql.sh

echo
echo "- - - - - - - - - - - - - - - - - - - - - - - -"
echo
echo "✅  all done"

WORKSPACE_URL="$(gp url)/#/workspace/evol-gitpod/.theia/workspace.theia-workspace"
echo -e "To open the evol workspace, Ctrl + click this link:\n$WORKSPACE_URL"
exit 0