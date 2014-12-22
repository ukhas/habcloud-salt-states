include:
  - .common

/etc/exim4/exim4.conf:
    file.managed:
      - source: salt://exim/relay.conf
      - template: jinja
      - mode: 644 
      - user: root
      - group: root
      - require:
          - pkg: exim4-daemon-light

exim4-dkim:
    cmd.run:
      - name: openssl genrsa -out /etc/exim4/dkim.key 2048
      - umask: 027
      - group: Debian-exim
      - creates: /etc/exim4/dkim.key
      - require:
          - pkg: exim4-daemon-light

/etc/aliases:
    file.managed:
      - source: salt://exim/aliases
      - template: jinja
      - mode: 644
      - user: root
      - group: root

extend:
    exim4:
        service.running:
          - watch:
              - file: /etc/aliases
              - cmd: exim4-dkim
