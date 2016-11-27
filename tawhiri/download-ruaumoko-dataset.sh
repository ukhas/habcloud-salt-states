#!/bin/bash
set -o errexit -o nounset -o pipefail
set -x
test ! -f /tmp/ruaumoko-dataset
sudo -Hu tawhiri /srv/tawhiri/bin/ruaumoko-download /tmp/ruaumoko-dataset
mv /tmp/ruaumoko-dataset /srv/ruaumoko-dataset
