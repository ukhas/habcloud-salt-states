rsyslog:
  service.running: []

/etc/rsyslog.d/habcloud-clients.conf:
  file.managed:
    - source: salt://monitoring/clients/rsyslog-clients.conf
    - watch_in:
      - service: rsyslog
