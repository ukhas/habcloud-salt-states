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

/root/habhub_backups_pubkey.asc:
  file.managed:
    - source: salt://backups/habhub_backups_pubkey.asc

backups-import-key:
  cmd.wait:
    - name: gpg --homedir /root/.gnupg/ --import /root/habhub_backups_pubkey.asc
    - watch:
      - file: /root/habhub_backups_pubkey.asc

/root/.s3cfg:
  file.managed:
    - source: salt://backups/s3cfg
    - mode: 600
    - template: jinja
