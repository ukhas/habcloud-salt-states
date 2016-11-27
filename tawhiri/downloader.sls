libffi5:
    pkg.installed

libgrib-api-1.9.16:
    pkg.installed

/usr/local/bin/tawhiri-downloader:
    file.managed:
      - source: https://github.com/cuspaceflight/tawhiri-downloader/releases/download/v1.0/tawhiri-downloader-v1.0-debian-wheezy
      - source_hash: sha256=ea58ca559168d30bddc506f8c2dbe6b50dbf68155ce5d75b443ad6514e97c0dd
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
