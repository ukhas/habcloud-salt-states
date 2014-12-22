{% for user, data in pillar["users"].items() %}
user-{{ user }}:
    group.present:
        - name: {{ user }}
        - gid: {{ data.uid }}
        - system: False
    user.present:
        - name: {{ user }}
        - password: !!
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
    file.managed:
        - name: /home/{{ user }}/.ssh/authorized_keys
        - mode: 640
        - user: {{ user }}
        - group: {{ user }}
        - contents_pillar: users:{{ user }}:ssh_keys
        - makedirs: true
        - dir_mode: 750
        - require:
            - user: {{ user }}
{% endfor %}

root:
    user.present:
        - password: !!

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
