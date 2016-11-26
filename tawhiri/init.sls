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

# This is a bash script for no good reason. I couldn't get the virtualenv
# salt state module to work. 
tawhiri-installed:
  cmd.script:
    - name: "salt://tawhiri/install-tawhiri.sh"
    - creates: /srv/tawhiri/.installed-stamp
    - user: tawhiri
    - require:
      - file: /srv/tawhiri
      - user: tawhiri
