include:
  - rust
  - supervisor

libssl-dev:
  pkg.installed: []

ukhasnet-influxdb:
  group.present: []
  user.present:
    - home: /home/ukhasnet-influxdb
    - system: true
    - gid_from_name: true
  git.latest:
    - name: https://github.com/adamgreig/ukhasnet-influxdb.git
    - target: /home/ukhasnet-influxdb/ukhasnet-influxdb
    - force: true
    - rev: master
    - user: ukhasnet-influxdb
    - always_fetch: true
  cmd.wait:
    - name: /usr/local/bin/cargo build --release
    - cwd: /home/ukhasnet-influxdb/ukhasnet-influxdb
    - watch:
      - git: ukhasnet-influxdb
      - cmd: install-rust
    - require:
      - pkg: libssl-dev
  supervisord.running:
    - restart: true
    - watch:
      - file: /etc/supervisor/conf.d/ukhasnet-influxdb.conf
      - file: /home/ukhasnet-influxdb/config.toml
      - cmd: ukhasnet-influxdb

/etc/supervisor/conf.d/ukhasnet-influxdb.conf:
  file.managed:
    - source: salt://ukhasnet/ukhasnet_influxdb_supervisor.conf
    - watch_in:
      - service: supervisor

/home/ukhasnet-influxdb/config.toml:
  file.managed:
    - source: salt://ukhasnet/ukhasnet_influxdb_config.toml
    - template: jinja
    - user: ukhasnet-influxdb
    - group: ukhasnet-influxdb
    - mode: 600
    - show_diff: false

/home/ukhasnet-influxdb/influxdb_backup.sh:
  file.managed:
    - source: salt://ukhasnet/influxdb_backup.sh
    - user: influxdb-ukhasnet
    - group: influxdb-ukhasnet
    - mode: 700
    - template: jinja
    - show_diff: false

{% from "backups/macros.jinja" import backup %}
{{ backup("ukhasnet-influxdb", "ukhasnet-influxdb",
          "/home/ukhasnet-influxdb/influxdb_backup.sh") }}
