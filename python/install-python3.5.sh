#!/bin/bash
set -o errexit -o pipefail -o nounset
set -x
tar xvfC /usr/local/src/Python-3.5.2.tgz /usr/local/src
cd /usr/local/src/Python-3.5.2
./configure
make
make install
touch /usr/local/src/Python-3.5.2/.installed-stamp
