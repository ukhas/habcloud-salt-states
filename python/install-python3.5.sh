#!/bin/sh
set -o errexit -o pipefail -o nounset
set -x
apt-get install \
    libreadline-dev libncursesw5-dev zlib1g-dev libdb-dev libgdbm-dev \
    libssl-dev libbz2-dev sharutils libexpat1-dev libsqlite3-dev libffi-dev \
    libfreetype6-dev libpng-dev
tar xvfC /usr/local/src/Python-3.5.2.tgz /usr/local/src
cd /usr/local/src/Python-3.5.2
./configure
make
make install
touch /usr/local/src/Python-3.5.2/.installed-stamp
