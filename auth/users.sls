{% for user, data in pillar["users"].items() %}
user-{{ user }}:
    group.present:
      - name: {{ user }}
      - gid: {{ data.uid }}
      - system: False
    user.present:
      - name: {{ user }}
      - password: "!"
      - home: /home/{{ user }}
      - shell: /bin/bash
      - uid: {{ data.uid }}
      - gid_from_name: True
      - fullname: {{ data.fullname }}
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

# By specifying these groups explicitly, deletion of users from
# pillar will result in ssh and sudo being disabled, and it will
# remove unrecognised users from sudo/users.
group-users:
    group.present:
      - name: users
      - system: true
      - members:
        {% for user in pillar["users"] %}
          - {{ user }}
        {% endfor %}

group-sudo:
    group.present:
      - name: sudo
      - system: true
      - members:
        {% for user, data in pillar["users"].items() %}
        {% if data.sudo %}
          - {{ user }}
        {% endif %}
        {% endfor %}

root:
    user.present:
      - password: "!"

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
