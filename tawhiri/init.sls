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

tawhiri-python:
    git.latest:
     - name: https://github.com/cuspaceflight/tawhiri
     - target: /srv/tawhiri
     - user: tawhiri
     - require:
         - file: /srv/tawhiri
