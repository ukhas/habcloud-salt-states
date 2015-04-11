#!/bin/sh
set -e
touch /srv/ukhas-data/incremental-stamp --date=yesterday
chown "ukhas-dokuwiki:" /srv/ukhas-data/incremental-stamp
