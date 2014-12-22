exim4:
    pkg:
      - name: exim4-daemon-light
      - installed

    service.running:
      - enable: True
      - watch:
          - file: /etc/exim4/exim4.conf
      - require:
          - pkg: exim4-daemon-light

distro-exim-conf:
    file.absent:
      - names:
          - /etc/exim4/exim4.conf.template
          - /etc/exim4/conf.d
          - /etc/exim4/passwd.client
