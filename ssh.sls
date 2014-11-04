openssh-server:
    pkg:
        - installed

ssh:
    server.running:
        - enable: True
        - watch:
            - file: /etc/ssh/sshd_config
            - pkg: openssh-server

no_ssh_passwords:
    file.sed:
        - name: /etc/ssh/sshd_config
        - before: "^#?PasswordAuthentication.+$"
        - after: "PasswordAuthentication no"
        - require:
            - pkg: openssh-server

no_ssh_root:
    file.sed:
        - name: /etc/ssh/sshd_config
        - before: "^#?PermitRootLogin.+$"
        - after: "PermitRootLogin no"
        - require:
            - pkg: openssh-server
