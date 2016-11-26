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
    - distribute: true
    - python: /usr/local/bin/python3
    - user: tawhiri
    - require:
      - cmd: python3-installed
      - user: tawhiri
      - file: /srv/tawhiri

tawhiri-pkg:
    pip.installed:
      - name: Tawhiri==0.2.0
      - user: tawhiri
      - bin_env: /srv/tawhiri
      - require: 
         - virtualenv: /srv/tawhiri
