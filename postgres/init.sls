postgresql-9.3:
    pkg.installed

/etc/postgresql/9.3/main/postgresql.conf:
    file.managed:
        - source: salt://postgres/postgresql.conf
        - template: jinja
        - mode: 644
        - user: postgres
        - group: postgres
        - require:
            - pkg: postgresql-9.3

/etc/postgresql/9.3/main/pg_hba.conf:
    file.managed:
        - source: salt://postgres/pg_hba.conf
        - template: jinja
        - mode: 600
        - user: postgres
        - group: postgres
        - require:
            - pkg: postgresql-9.3

postgresql:
    service.running:
        - reload: true
        - enable: true
        - watch:
            - pkg: postgresql-9.3
            - file: /etc/postgresql/9.3/main/postgresql.conf
            - file: /etc/postgresql/9.3/main/pg_hba.conf

{% for group in pillar['postgres']['groups'] %}
{{ group }}-pg-group:
    postgres_group.present:
        - name: {{ group }}
        - inherit: true
        - user: postgres
        - require:
            - service: postgresql
{% endfor %}

{% for user in pillar['postgres']['users'] %}
{{ user }}-pg-user:
    postgres_user.present:
        - name: {{ pillar[user + '-pg-user']['username'] }}
        - password: {{ pillar[user + '-pg-user']['password'] }}
        - groups: {{ pillar[user + '-pg-user']['groups']|join(',') }}
        - user: postgres
        - require:
            - service: postgresql
            {% for group in pillar['postgres']['groups'] %}
            - postgres_group: {{ group }}
            {% endfor %}
{% endfor %}

{% for database in pillar['postgres']['databases'] %}
{{ database }}-pg-database:
    postgres_database.present:
        - name: {{ database }}
        - encoding: {{ pillar['postgres']['databases'][database]['encoding'] }}
        - lc_collate: {{ pillar['postgres']['databases'][database]['lc_collate'] }}
        - lc_ctype: {{ pillar['postgres']['databases'][database]['lc_ctype'] }}
        - owner: {{ pillar['postgres']['databases'][database]['owner'] }}
        - template: {{ pillar['postgres']['databases'][database]['template'] }}
        - user: postgres
        - require:
            - service: postgresql
            {% for group in pillar['postgres']['groups'] %}
            - postgres_group: {{ group }}
            {% endfor %}
            {% for user in pillar['postgres']['users'] %}
            - postgres_user: {{ user }}
            {% endfor %}
{% endfor %}
