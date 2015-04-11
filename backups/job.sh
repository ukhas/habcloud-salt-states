#!/bin/bash
# Backup job {{ name }}

set -e
set -o pipefail

# The user running the backup job probably can't operate from /root
cd /

# Run the specified command as the right user, nice and ioniced to avoid
# unnecessarily loading the system, then pipe the result to our backup
# pipeline which gzips, encrypts and uploads to S3.
sudo -u {{ user }} nice ionice -c 3 {{ cmd }} |
sudo -u backups    nice ionice -c 3 /home/backups/backup.sh \
    s3://{{ grains.id }}/{{ name }}-$(date +'%Y%m%dT%H%M%S').gz.gpg
