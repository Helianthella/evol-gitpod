#!/bin/bash

# set up git
git config --global url.https:.pushInsteadOf git:

if [[ ! -z "$GIT_AUTHOR_NAME" ]]; then
    git config --global user.name $GIT_AUTHOR_NAME
fi

if [[ ! -z "$GIT_AUTHOR_EMAIL" ]]; then
    git config --global user.email $GIT_AUTHOR_EMAIL
fi


# set up the dotfiles
DOTFILES_OK=$(tail ~/.bashrc | grep -sc "exec zsh" || true)

if [ "$DOTFILES_OK" != "0" ]; then
    exit
fi

cd /workspace/evol-gitpod


# custom mods
if [[ ! -z "$CUSTOM_MODS" ]]; then
    if [[ ! -d ".gitpod-config" ]]; then
        git clone --depth=1 -q "$CUSTOM_MODS" .gitpod-config &>/dev/null
    fi
    pushd .gitpod-config &>/dev/null
    make &>/dev/null
    popd &>/dev/null
fi



# seppuku prompt
if [[ ! -d "seppuku" ]]; then
    curl -Lo ohmyzsh.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh &>/dev/null
    git clone https://github.com/Helianthella/seppuku.git seppuku &>/dev/null
fi
sh ohmyzsh.sh --unattended &>/dev/null
pushd seppuku &>/dev/null
make install &>/dev/null
popd &>/dev/null
echo "exec zsh" >> ~/.bashrc
echo "ZSH_THEME_TERM_TITLE_IDLE=\"\${ZSH_THEME_TERM_TAB_TITLE_IDLE}\"" >> ~/.zshrc
echo "unalias gp" >> ~/.zshrc # workaround for ohmyzsh:plugins/git/git.plugin.zsh
