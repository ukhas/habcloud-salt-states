#!/bin/bash
# Backup script for HabCloud
# This script gets piped data to backup on stdin, in raw form
# The script compresses, encrypts and uploads this data to Amazon S3
#
# $1 should be something like...
# s3://whatever.vm.habhub.org/postgres-20150101T010101.gz.gpg

cat | gzip |
gpg --homedir /home/backups/.gnupg --always-trust -er CB18E7F8 |
s3cmd put -q - $1
