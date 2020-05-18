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
cp -f .gitpod/git/exclude .git/info/exclude


# TODO: DRY this

function git_pull() {
    local DIR="$1"
    if [ -d "$DIR" ]; then
        local REMOTE="upstream"
        local BRANCH="master"
        local UPSTREAM="$REMOTE/$BRANCH"

        pushd $DIR 1>/dev/null
        git fetch $REMOTE

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
    else
        . "./.gitpod/scripts/init/${DIR}.sh"
    fi
}

git_pull "tools"

if [ -d "server-code" ]; then
    REMOTE="upstream"
    BRANCH="master"
    UPSTREAM="$REMOTE/$BRANCH"

    pushd server-code 1>/dev/null
    git fetch $REMOTE

    CURRENT=$(git rev-parse --abbrev-ref --symbolic-full-name @{u})
    CURRENT_BRANCH=$(git symbolic-ref --short HEAD)

    if [ "$CURRENT" = "$UPSTREAM" ] && [ "$CURRENT_BRANCH" = "$BRANCH" ]; then
        LOCAL=$(git rev-parse @)
        #REMOTE=$(git rev-parse "$UPSTREAM")
        BASE=$(git merge-base @ "$UPSTREAM")

        if [ $LOCAL = $BASE ]; then
            # we are on upstream/master and can fast-forward
            git pull -q
        fi
    fi

    pushd src/evol 1>/dev/null
    git fetch $REMOTE

    CURRENT=$(git rev-parse --abbrev-ref --symbolic-full-name @{u})
    CURRENT_BRANCH=$(git symbolic-ref --short HEAD)

    if [ "$CURRENT" = "$UPSTREAM" ] && [ "$CURRENT_BRANCH" = "$BRANCH" ]; then
        LOCAL=$(git rev-parse @)
        #REMOTE=$(git rev-parse "$UPSTREAM")
        BASE=$(git merge-base @ "$UPSTREAM")

        if [ $LOCAL = $BASE ]; then
            # we are on upstream/master and can fast-forward
            git pull -q
        fi
    fi
    popd 1>/dev/null
    popd 1>/dev/null
else
    ./.gitpod/scripts/init/server-code.sh
fi

git_pull "server-data"
git_pull "client-data"

./.gitpod/scripts/sql.sh

echo
echo "✅  all done"
exit 0