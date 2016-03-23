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

# TODO: Ship a config file that restricts ports to localhost only and sets
# admin password perhaps, add to service watch list

# TODO: Add InfluxDB backups
# {% from "backups/macros.jinja" import backup %}
# {{ backup("ukhasnet-influxdb", "username", "cmd") }}
