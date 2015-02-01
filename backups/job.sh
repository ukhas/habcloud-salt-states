#!/bin/bash
# Backup job {{ name }}

sudo -u {{ user }} nice ionice -c 3 {{ cmd }} |
sudo -u backups    nice ionice -c 3 /home/backups/backup.sh \
    s3://{{ grains.id }}/{{ name }}-$(date +'%Y%m%dT%H%M%S').gz.gpg
