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

/root/influxdb_setup.sh:
  file.managed:
    - source: salt://ukhasnet/influxdb_setup.sh
    - user: root
    - group: root
    - mode: 700
    - template: jinja
    - show_diff: false
  cmd.wait:
    - output_loglevel: quiet
    - require:
      - service: influxdb
    - watch:
      - file: /root/influxdb_setup.sh

/root/influxdb_backup.sh:
  file.managed:
    - source: salt://ukhasnet/influxdb_backup.sh
    - user: root
    - group: root
    - mode: 700
    - template: jinja
    - show_diff: false

{% from "backups/macros.jinja" import backup %}
{{ backup("ukhasnet-influxdb", "influxdb", "/root/influxdb_backup.sh") }}
