{% for user, data in pillar["users"].items() %}
user-{{ user }}:
    group.present:
        - system: False
    user.present:
        - home: /home/{{ user }}
        - shell: /bin/bash
        - uid: {{ data.uid }}
        - gid_from_name: True
        {% if data.sudo %}
        - groups:
            - sudo
        {% endif %}
        - require:
            - group: {{ user }}
            - file: passwordless_sudo
    ssh_auth.present:
        - user: {{ user }}
        - names:
        {% for ssh_key in data.ssh_keys %}
            - {{ ssh_key }}
        {% endfor %}
        - require:
            - user: {{ user }}
{% endfor %}

root:
    user.present:
        - password: !

passwordless_sudo:
    file.sed:
        - name: /etc/sudoers
        - before: "^%sudo\\s+ALL=\\(ALL:ALL\\) ALL"
        - after: "%sudo ALL=(ALL:ALL) NOPASSWD:ALL"
