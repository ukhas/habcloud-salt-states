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

/root/influxdb_setup.txt:
  file.managed:
    - source: salt://ukhasnet/influxdb_setup.txt
    - user: root
    - group: root
    - mode: 600
    - template: jinja
    - show_diff: false

influxdb-setup:
  cmd.run:
    - name: |
      influx \
       -username admin \
       -password "{{ pillar['ukhasnet']['influxdb']['admin_password'] }}" \
      < /root/influxdb_setup.txt
    - shell: /bin/sh
    - output_loglevel: quiet

# TODO: Add InfluxDB backups
# {% from "backups/macros.jinja" import backup %}
# {{ backup("ukhasnet-influxdb", "username", "cmd") }}
