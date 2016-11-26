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
  virtualenv.managed:
    - distribute: true
    - python: /usr/local/bin/python3
    - user: tawhiri
    - require:
      - cmd: python3-installed
    - pip_pkgs:
      - Tawhiri==0.2.0
