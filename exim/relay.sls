include:
  - .common

/etc/exim4/exim4.conf:
    file.managed:
      - source: salt://exim/relay.conf
      - mode: 644 
      - user: root
      - group: root
      - require:
          - pkg: exim4

exim4-dkim:
    cmd.run:
      - name: openssl genrsa -out /etc/exim4/dkim.key 2048
      - umask: 057
      - creates: /etc/exim4/dkim.key
