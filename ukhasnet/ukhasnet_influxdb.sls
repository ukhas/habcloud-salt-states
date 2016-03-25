include:
  - rust
  - supervisor

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
    - name: cargo build --release
    - cwd: /home/ukhasnet-influxdb/ukhasnet-influxdb
    - watch:
      - git: ukhasnet-influxdb
      - cmd: install-rust
  supervisord.running:
    - restart: true
    - watch:
      - file: /etc/supervisor/conf.d/ukhasnet-influxdb.conf
      - file: /home/ukhasnet_influxdb/config.toml
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
