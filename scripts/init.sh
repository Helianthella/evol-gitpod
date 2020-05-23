#!/bin/bash

mkdir -p /workspace/evol-gitpod/.evol
cd /workspace/evol-gitpod/.evol

# clone all of our other repos
git clone https://gitlab.com/manaplus/manaplus.git --origin upstream manaplus
git clone https://gitlab.com/evol/clientdata.git --origin upstream client-data
git clone https://gitlab.com/evol/serverdata.git --origin upstream server-data
git clone https://gitlab.com/evol/evol-tools.git --origin upstream tools
git clone https://gitlab.com/evol/hercules.git --origin upstream server-code
git clone https://gitlab.com/evol/evol-hercules.git --origin upstream server-code/src/evol

# symlink the plugin
ln -s /workspace/evol-gitpod/.evol/server-code/src/evol /workspace/evol-gitpod/.evol/server-plugin

# build hercules
pushd server-data
make conf
make build
popd

# build manaplus
pushd manaplus
autoreconf -i
mkdir -p ~/.local
./configure --quiet --prefix=/home/gitpod/.local
make
make install
popd

# seppuku prompt
curl -Lo install.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
sh install.sh --unattended
rm install.sh
git clone https://github.com/Helianthella/seppuku.git ~/.seppuku
pushd ~/.seppuku
make install
popd
echo "exec zsh" >> ~/.bashrc
echo "ZSH_THEME_TERM_TITLE_IDLE=\"\${ZSH_THEME_TERM_TAB_TITLE_IDLE}\"" >> ~/.zshrc
