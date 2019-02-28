libffi5:
    pkg.installed

libgrib-api-1.9.16:
    pkg.installed

/usr/local/bin/tawhiri-downloader:
    file.managed:
      - source: https://github.com/cuspaceflight/tawhiri-downloader/releases/download/v2.0/tawhiri-downloader-debian-wheezy
      - source_hash: sha256=a9da912e31d5cf4c285483001ac3499583579fd9a889b802ececdb95ccd54a80
      - mode: 755

/etc/supervisor/conf.d/tawhiri-downloader.conf:
  file.managed:
    - source: salt://tawhiri/downloader.supervisor.conf
    - require:
      - file: /usr/local/bin/tawhiri-downloader
      - file: /srv/tawhiri-datasets

supervisor-tawhiri-downloader:
  supervisord.running:
    - name: tawhiri-downloader
    - update: true
    - watch:
      - file: /etc/supervisor/conf.d/tawhiri-downloader.conf
      - file: /usr/local/bin/tawhiri-downloader
    - require:
      - file: /etc/supervisor/conf.d/tawhiri-downloader.conf
