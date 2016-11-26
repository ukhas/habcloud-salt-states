#!/bin/bash
set -o errexit -o pipefail -o nounset
set -x

virtualenv /srv/tawhiri
/srv/tawhiri/bin/pip install Tawhiri==0.2.0
