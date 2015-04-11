#!/bin/sh
set -e
touch /tmp/ukhas-dokuwiki-incremental-start
find /srv/ukhas-data -type f > /tmp/ukhas-dokuwiki-file-list
tar c /srv/ukhas-data /tmp/ukhas-dokuwiki-file-list \
    --newer /srv/ukhas-data/incremental-stamp \
    --exclude=/srv/ukhas-data/data/cache -P
touch /srv/ukhas-data/incremental-stamp --reference=/tmp/ukhas-dokuwiki-incremental-start
rm /tmp/ukhas-dokuwiki-incremental-start /tmp/ukhas-dokuwiki-file-list
