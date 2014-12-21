openssh-server:
    pkg:
        - installed

ssh:
    server.running:
        - enable: True
        - watch:
            - file: /etc/ssh/sshd_config
            - pkg: openssh-server

/etc/ssh/sshd_config:
    file.managed:
        - source: salt://auth/sshd_config
        - mode: 644
        - user: root
        - group: root
        - require:
            - pkg: openssh-server
