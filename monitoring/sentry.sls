include:
  - postgres.9_1
  - nginx
  - supervisor

sentry_deps:
  pkg.installed:
    - names:
      - redis-server
      - libxslt1-dev
      - libxml2-dev
      - python-psycopg2
      - python-dev

sentry:
  group.present: []
  postgres_user.present: []
  user.present:
    - home: /home/sentry   # TODO: Or /srv or /opt or..?
    - system: true
    - gid_from_name: true
  postgres_database.present:
    - owner: sentry

/home/sentry/venv:
  virtualenv.managed:
    - system_site_packages: true
    - distribute: true
    - user: sentry
    - group: sentry

sentry_code:
  pip.installed:
    - name: sentry
    - bin_env: /home/sentry/venv
    - user: sentry

sentry_conf:
  file.managed:
    - name: /home/sentry/.sentry/sentry.conf.py
    - source: salt://monitoring/sentry.conf.py
    - makedirs: true
    - user: sentry
    - group: sentry
    - mode: 600

sentry_nginx:
  file.managed:
    - name: /etc/nginx/conf.d/sentry.habhub.org.conf
    - source: salt://monitoring/sentry-nginx.conf
    - template: jinja
    - watch_in:
      - service: nginx

# supervisor+gunicorn
{% from "gunicorn/macros.jinja" import gunicorn %}
{{ gunicorn(name="sentry", user="sentry", venv="/home/sentry/venv",
            dir="/home/sentry", app="sentry.wsgi",
            workers=2) }}

# queue workers supervisord
sentry-workers:
  file.managed:
    - name: /etc/supervisor/conf.d/sentry-workers.conf
    - source: salt://monitoring/sentry-workers-supervisord.conf
    - watch_in:
      - service: supervisor
  supervisord.running:
    - require:
      - file: sentry-workers
