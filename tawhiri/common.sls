include:
  - python
  - postgres.9_1

tawhiri:
  group.present: []
  user.present:
    - home: /srv/tawhiri
    - createhome: false
    - system: true
    - gid_from_name: true
  postgres_user.present: []
  postgres_database.present:
    - owner: postgres

create-predictions-table:
  cmd.script:
    - name: "salt://tawhiri/create-predictions-table.sh"
    - creates: /srv/tawhiri/.created-predictions-table
    - require:
      - postgres_database: tawhiri
      - postgres_user: tawhiri

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
    - creates: /srv/tawhiri/bin/python3
    - require:
      - user: tawhiri
      - file: /srv/tawhiri

imagemagick:
  pkg.installed: []

ruaumoko-installed:
  cmd.run:
    - name: "/srv/tawhiri/bin/pip3 install Ruaumoko==0.2.0"
    - user: tawhiri
    - creates: /srv/tawhiri/bin/ruaumoko-download
    - require:
      - cmd: tawhiri-venv

ruaumoko-dataset:
  cmd.script:
    - name: "salt://tawhiri/download-ruaumoko-dataset.sh"
    - creates: /srv/ruaumoko-dataset
    - require:
      - cmd: ruaumoko-installed
      - pkg: imagemagick

tawhiri-downloader:
    group.present: []
    user.present:
      - home: /srv/tawhiri-downloader
      - createhome: false
      - system: true
      - gid_from_name: true

/srv/tawhiri-datasets:
    file.directory:
      - dir_mode: 775 
      - group: tawhiri-downloader
      - require:
          - group: tawhiri-downloader
