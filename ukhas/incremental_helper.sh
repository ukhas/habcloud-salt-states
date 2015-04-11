#!/bin/sh
set -e
touch /tmp/ukhas-dokuwiki-incremental-start
tar c /srv/ukhas-data \
    --newer /srv/ukhas-data/incremental-stamp \
    --exclude=/srv/ukhas-data/data/cache
touch /srv/ukhas-data/incremental-stamp --reference=/tmp/ukhas-dokuwiki-incremental-start
rm /tmp/ukhas-dokuwiki-incremental-start
