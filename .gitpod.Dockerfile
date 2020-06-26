FROM gitpod/workspace-mysql

USER gitpod

# use apt mirrors for faster fetching
RUN sudo sed -i -e 's%https\?://\(us.\)\?archive.ubuntu.com/ubuntu/%mirror://mirrors.ubuntu.com/mirrors.txt%' /etc/apt/sources.list

RUN wget http://repo.evolonline.org/manaplus/ubuntu/manaplus-addrepo_1.3_all.deb \
 && sudo apt install -yy -qq ./manaplus-addrepo_1.3_all.deb \
 && rm manaplus-addrepo_1.3_all.deb \
 && sudo sed -i "s/manaplus \w\+ /manaplus disco /" /etc/apt/sources.list.d/mana* \
 && echo "deb-src http://repo.evolonline.org/manaplus disco main" | sudo tee -a /etc/apt/sources.list.d/manaplusauto.list \
 && sudo apt-get update \
 && sudo apt-get install -yy \
    manaplus valgrind gdb \
    make autoconf automake autopoint libtool libz-dev \
    libmysqlclient-dev zlib1g-dev libpcre3-dev doxygen \
    cpanminus libexpat1 libexpat1-dev wget tmux ripgrep \
    xvfb x11vnc xterm zsh \
 && curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash - \
 && sudo apt-get install -yy nodejs \
 && sudo apt-get build-dep -yy manaplus \
 && sudo cpanm XML::Simple \
 && sudo apt-get clean \
 && sudo rm -rf /var/lib/apt/lists/*

RUN sudo ln -s /usr/games/manaplus /usr/bin/manaplus


# noVNC (from gitpod/workspace-full-vnc:latest)
RUN sudo git clone https://github.com/novnc/noVNC.git /opt/novnc \
 && sudo git clone https://github.com/novnc/websockify /opt/novnc/utils/websockify \
 && sudo wget -O /opt/novnc/index.html https://raw.githubusercontent.com/gitpod-io/workspace-images/master/full-vnc/novnc-index.html \
 && sudo wget -O /usr/bin/start-vnc-session.sh https://raw.githubusercontent.com/gitpod-io/workspace-images/master/full-vnc/start-vnc-session.sh \
 && sudo chmod +x /usr/bin/start-vnc-session.sh

# This is a bit of a hack. At the moment we have no means of starting background
# tasks from a Dockerfile. This workaround checks, on each bashrc eval, if the X
# server is running on screen 0, and if not starts Xvfb, x11vnc and novnc.
RUN echo "[ ! -e /tmp/.X0-lock ] && (/usr/bin/start-vnc-session.sh 0 &> /tmp/display-0.log)" >> ~/.bashrc
RUN echo "export DISPLAY=:0" >> ~/.bashrc

### checks ###
# no root-owned files in the home directory
RUN notOwnedFile=$(find . -not "(" -user gitpod -and -group gitpod ")" -print -quit) \
    && { [ -z "$notOwnedFile" ] \
        || { echo "Error: not all files/dirs in $HOME are owned by 'gitpod' user & group"; exit 1; } }
