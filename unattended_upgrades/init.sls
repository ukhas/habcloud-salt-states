unattended-upgrades:
    pkg.installed

/etc/apt/apt.conf.d/50unattended-upgrades:
    file.managed:
      - source: salt://unattended_upgrades/50unattended-upgrades
      - mode: 644
      - user: root
      - group: root
      - require:
          - pkg: unattended-upgrades
