include:
  - supervisor
  - python
  - .downloader

tawhiri:
    group.present: []
    user.present:
      - home: /srv/tawhiri
      - createhome: false
      - system: true
      - gid_from_name: true

/srv/tawhiri:
  file.directory:
    - dir_mode: 775
    - group: tawhiri
    - require:
      - group: tawhiri
  virtualenv.managed:
    - requirements: salt://tawhiri/tawhiri.txt
    - python: /usr/local/bin/python3
    - user: tawhiri
    - require:
      - cmd: python3-installed
      - user: tawhiri
      - file: /srv/tawhiri
