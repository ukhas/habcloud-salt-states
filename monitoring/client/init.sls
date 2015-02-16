rsyslog:
  service.running: []

/etc/rsyslog.d/habcloud-client.conf:
  file.managed:
    - source: salt://monitoring/client/rsyslog-client.conf
    - watch_in:
      - service: rsyslog

/etc/salt/minion.d/logging.conf:
  file.managed:
    - source: salt://monitoring/client/salt_logging.conf

restart_minion_after_logging_conf:
  cmd.wait:
    - name: nohup /bin/sh -c 'sleep 10 && salt-call --local service.restart salt-minion'
    - python_shell: True
    - order: last
    - watch:
      - file: /etc/salt/minion.d/logging.conf
