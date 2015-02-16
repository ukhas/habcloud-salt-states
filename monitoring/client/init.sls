rsyslog:
  service.running: []

/etc/rsyslog.d/habcloud-client.conf:
  file.managed:
    - source: salt://monitoring/client/rsyslog-client.conf
    - watch_in:
      - service: rsyslog
