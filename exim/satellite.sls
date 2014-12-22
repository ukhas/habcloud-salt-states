include: exim.common

/etc/exim4/exim4.conf:
    file.managed:
      - source: salt://exim/satellite.conf
      - template: jinja
      - defaults:
          - upstream: support
      - mode: 644 
      - user: root
      - group: root
      - require:
          - pkg: exim4
