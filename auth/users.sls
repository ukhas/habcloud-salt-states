{% set users = pillar["auth"]["users"] %}
{% set groups = pillar["auth"]["groups"][grains.id] %}
{% set sudoers = groups["sudo"] %}
{% set normal_users = groups.get("users", []) %}
{% set all_vm_users = sudoers + normal_users %}

{% for user, data in users.items() if user in all_vm_users %}
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
      - remove_groups: False
      - require:
          - group: {{ user }}
    file.managed:
      - name: /home/{{ user }}/.ssh/authorized_keys
      - mode: 600
      - user: {{ user }}
      - group: {{ user }}
      - contents_pillar: auth:users:{{ user }}:ssh_keys
      - makedirs: true
      - dir_mode: 700
      - show_diff: false
      - require:
          - user: {{ user }}
{% endfor %}

{% for user in users.keys() if user not in all_vm_users %}
remove-user-{{ user }}:
    user.absent:
        - name: {{ user }}
        - force: true
        - purge: false
{% endfor %}

group-users:
    group.present:
        - name: users
        - system: true
        - members:
          {% for user in all_vm_users %}
            - {{ user }}
          {% endfor %}

{% for group, members in groups.items() %}
{% if group != "users" %}
group-{{ group }}:
    group.present:
        - name: {{ group }}
        - system: {{ "true" if group == "sudo" else "false" }}
        - members:
          {% for user in members %}
            - {{ user }}
          {% endfor %}
{% endif %}
{% endfor %}

add-sudoers-to-adm:
    group.present:
        - name: adm
        - system: true
        - addusers:
          {% for user in sudoers %}
            - {{ user }}
          {% endfor %}

root:
    user.present:
      - password: "!"

    file.managed:
      - name: /root/.ssh/authorized_keys
      - mode: 600
      - user: root
      - group: root
      - contents_pillar: auth:root_ssh_keys
      - makedirs: true
      - dir_mode: 700
      - show_diff: false

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

/etc/pam.d/common-session:
    file.append:
      - text: 'session optional pam_umask.so usergroups umask=0022'

/etc/pam.d/common-session-noninteractive:
    file.append:
      - text: 'session optional pam_umask.so usergroups umask=0022'
