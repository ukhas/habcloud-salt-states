{% macro gunicorn(name, user, venv, dir, app) %}
/etc/supervisor/conf.d/{{ name }}.conf:
  file.managed:
    - source: salt://gunicorn/supervisor.conf
    - template: jinja
    - context:
        name: {{ name }}
        venv_path: {{ venv }}
        app: {{ app }}
        socket: /var/lib/gunicorn/{{ user }}/{{ name }}.sock
        num_workers: 2
        program_dir: {{ dir }}
        user: {{ user }}
    - watch_in:
        - service: supervisor
    - require:
        - sls: supervisor

/var/lib/gunicorn/{{ user }}:
  file.directory:
    - user: {{ user }}
    - group: www-data
    - dir_mode: 750
{% endmacro %}
