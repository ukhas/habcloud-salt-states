{% for user, data in pillar["users"].items() %}
user-{{ user }}:
    group.present:
        - name: {{ user }}
        - gid: {{ data.uid }}
        - system: False
    user.present:
        - name: {{ user }}
        - password: !
        - home: /home/{{ user }}
        - shell: /bin/bash
        - uid: {{ data.uid }}
        - gid_from_name: True
        - groups:
            - users
        {% if data.sudo %}
            - sudo
        {% endif %}
        - require:
            - group: {{ user }}
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

sudo:
    pkg:
        - installed

/etc/sudoers:
    file.managed:
        - source: salt://auth/sudoers
        - mode: 440
        - user: root
        - group: root
        - require:
            - pkg: sudo
