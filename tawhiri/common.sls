include:
  - python

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

tawhiri-venv:
  cmd.run:
    - name: "pyvenv-3.5 /srv/tawhiri"
    - user: tawhiri
    - creates: /srv/tawhiri/.pyvenv-setup-stamp
    - require:
      - user: tawhiri
      - file: /srv/tawhiri

imagemagick:
  pkg.installed: []

ruaumoko-installed:
  cmd.run:
    - name: "/srv/tawhiri/bin/pip3 install Ruaumoko==0.2.0"
    - user: tawhiri
    - creates: /srv/tawhiri/.ruaumoko-installed
    - require:
      - cmd: tawhiri-venv

ruaumoko-dataset:
  cmd.script:
    - name: "salt://tawhiri/download-ruaumoko-dataset.sh"
    - creates: /srv/ruaumoko-dataset
    - require:
      - cmd: ruaumoko-installed
      - pkg: imagemagick
