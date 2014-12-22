ntp:
    pkg.installed
    service.running:
      - enable: True
      - watch:
          - file: /etc/ntp.conf
          - pkg: ntp

/etc/ntp.conf:
    file.managed:
      - source: salt://ntp/ntp.conf
      - template: jinja
      - mode: 644
      - user: root
      - group: root
      - require:
          - pkg: ntp
