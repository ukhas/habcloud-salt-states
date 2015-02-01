# HabCloud backup management
# The overall strategy is:
# * Each VM gets its own S3 bucket and IAM user, permitted only to upload
#   objects into that S3 bucket
# * All buckets have a lifecycle configuration that immediately transfers files
#   Glacier and deletes them entirely after one year
# * All backup jobs are pipes that end with gzip | gpg | s3cmd, uploading
#   compressed and encrypted files to S3
# * All backup files are encrypted to the Habhub Backups public key
# * Recovery is definitely a manual operation at the moment

s3cmd:
  pip.installed

gnupg:
  pkg.installed

backups-user:
  group:
    - name: backups
    - system: true
  user:
    - name: backups
    - gid_from_name: true
    - system: true
    - home: /home/backups

/home/backups/habhub_backups_pubkey.asc:
  file.managed:
    - source: salt://backups/habhub_backups_pubkey.asc
    - user: backups

backups-import-key:
  cmd.wait:
    - name: gpg --homedir /root/.gnupg --import /root/habhub_backups_pubkey.asc
    - user: backups
    - watch:
      - file: /home/backups/habhub_backups_pubkey.asc

/home/backups/.s3cfg:
  file.managed:
    - source: salt://backups/s3cfg
    - user: backups
    - mode: 600
    - template: jinja

/home/backups/backup.sh:
  file.managed:
    - source: salt://backups/backup.sh
    - mode: 700
    - user: backups
