#!/bin/bash
set -o errexit -o pipefail -o nounset
set -x

pyvenv-3.5 /srv/tawhiri
/srv/tawhiri/bin/pip3 install Ruaumoko==0.2.0 Tawhiri==0.2.0 gunicorn
