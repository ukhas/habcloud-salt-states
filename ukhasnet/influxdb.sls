include:
  - backups

influxdb:
  pkgrepo.managed:
    - name: deb https://repos.influxdata.com/debian wheezy stable
    - file: /etc/apt/sources.list.d/influxdb.list
    - key_url: https://repos.influxdata.com/influxdb.key
  pkg.installed: []
  service.running:
    - reload: true
    - enable: true
    - watch:
      - file: /etc/influxdb/influxdb.conf

/etc/influxdb/influxdb.conf:
  file.managed:
    - source: salt://ukhasnet/influxdb.conf
    - user: root
    - group: root
    - mode: 644

# TODO: Add InfluxDB backups
# {% from "backups/macros.jinja" import backup %}
# {{ backup("ukhasnet-influxdb", "username", "cmd") }}
