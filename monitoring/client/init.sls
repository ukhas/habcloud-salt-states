rsyslog:
  service.running: []

/etc/rsyslog.d/habcloud-client.conf:
  file.managed:
    - source: salt://monitoring/clients/rsyslog-client.conf
    - watch_in:
      - service: rsyslog
