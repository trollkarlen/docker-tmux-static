#!/bin/bash

set -e
set -x

VERSION="${TMUX_VERSION:-3.1}"
NCURSES_VERSION="${NCURSES_VERSION:-6.2}"
LIBEVENT_VERSION="${LIBEVENT_VERSION:-2.1.12}"

# based on: https://gist.github.com/pistol/5069697

# ncurses
wget http://ftp.gnu.org/pub/gnu/ncurses/ncurses-$NCURSES_VERSION.tar.gz
tar xvzf ncurses-$NCURSES_VERSION.tar.gz
cd ncurses-$NCURSES_VERSION
./configure --prefix=$HOME/local
make -j8
make install
cd ..

# libevent
git clone git://github.com/libevent/libevent.git
cd libevent
git checkout release-$LIBEVENT_VERSION-stable
./autogen.sh
./configure --prefix=$HOME/local
make -j8
make install
cd ..

# tmux
git clone https://github.com/tmux/tmux.git tmux-src
cd tmux-src
git checkout $VERSION
./autogen.sh
./configure --prefix=$HOME/local CPPFLAGS="-I$HOME/local/include -I$HOME/local/include/ncurses" LDFLAGS="-static -L$HOME/local/include -L$HOME/local/include/ncurses -L$HOME/local/lib"
make -j8
make install

cp tmux ..
