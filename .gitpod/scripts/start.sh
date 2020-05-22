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
    export GITLAB_NAME=$(git remote get-url origin | sed -r "s#.+\.com[:/]{1,2}([^/]+)/.+#\1#")
elif [ "${REPO_REMOTE:8:10}" = "github.com" ]; then
    export GITHUB_NAME=$(git remote get-url origin | sed -r "s#.+\.com[:/]{1,2}([^/]+)/.+#\1#")
fi

# apply our custom gitignore:
#cp -f .gitpod/git/exclude .git/info/exclude

# symlink the prefetched repos
ln -sf ~/.evol/server-data server-data
ln -sf ~/.evol/client-data client-data
ln -sf ~/.evol/server-code server-code
ln -sf ~/.evol/server-code/src/evol server-plugin
ln -sf ~/.evol/tools tools
ln -sf ~/.evol/manaplus manaplus

function git_pull() {
    local DIR="$1"
    local REMOTE="upstream"
    local BRANCH="master"
    local UPSTREAM="$REMOTE/$BRANCH"

    pushd $DIR 1>/dev/null
    git fetch $REMOTE

    local UPSTREAM_URL=$(git config --get remote.upstream.url)
    local FORK_URL=$(git config --get remote.origin.url 2>/dev/null || echo "")

    if [[ ! -z "$GITLAB_NAME" ]] && [ -z "$FORK_URL" ]; then
        FORK_URL=$(git config --get remote.upstream.url | sed -r "s%https://gitlab.com/([^/]+)/(.+(\.git)?)%https://gitlab.com/$GITLAB_NAME/\2%")
        git remote add --fetch origin "$FORK_URL"
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

git_pull "tools"
git_pull "server-code"
git_pull "server-plugin"
git_pull "server-data"
git_pull "client-data"

# set up extra repos for Hercules development
pushd server-code
HERC_FORK_URL=$(git config --get remote.herc.url 2>/dev/null || echo "")
if [[ ! -z "$GITHUB_NAME" ]] && [ -z "$HERC_FORK_URL" ]; then
    git remote add hub "https://github.com/$GITHUB_NAME/Hercules.git"
fi
popd

./.gitpod/scripts/sql.sh

echo
echo "✅  all done"
exit 0