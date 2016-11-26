tawhiri-downloader:
    group.present: []
    user.present:
      - home: /srv/tawhiri-downloader
      - createhome: false
      - system: true
      - gid_from_name: true

/srv/tawhiri-datasets:
    file.directory:
      - dir_mode: 755
      - group: tawhiri-downloader
      - require:
          - group: tawhiri-downloader

libffi5:
  pkg.installed

libgrib-api-1.9.16:
  pkg.installed

/usr/local/bin/tawhiri-downloader:
    file.managed:
      - source: https://github.com/cuspaceflight/tawhiri-downloader/releases/download/1.0/tawhiri-downloader-v1.0-debian-wheezy

/etc/supervisor/conf.d/tawhiri-downloader.conf:
  file.managed:
    - source: salt://tawhiri/downloader.supervisor.conf
    - watch_in:
      - service: supervisor
    - require:
      - file: /usr/local/bin/tawhiri-downloader
      - file: /srv/tawhiri-datasets

supervisor-tawhiri-downloader:
  supervisord.running:
    - name: tawhiri-downloader
    - watch:
      - file: /etc/supervisor/conf.d/tawhiri-downloader.conf
      - file: /usr/local/bin/tawhiri-downloader
