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
  cmd.wait:
    - name: /home/sentry/venv/bin/sentry upgrade
    - wait:
      - pip: sentry_code

sentry_conf:
  file.managed:
    - name: /home/sentry/.sentry/sentry.conf.py
    - contents_pillar: "monitoring:sentry_conf"
    - makedirs: true
    - user: sentry
    - group: sentry
    - mode: 600
    - show_diff: false
    - watch_in:
      - supervisord: sentry-web
      - supervisord: sentry-workers


{% from "nginx/macros.jinja" import deploy_ssl_files %}
{{ deploy_ssl_files("sentry.habhub.org") }}

sentry_nginx:
  file.managed:
    - name: /etc/nginx/conf.d/sentry.habhub.org.conf
    - source: salt://monitoring/sentry/nginx-site.conf
    - template: jinja
    - watch_in:
      - service: nginx

# supervisor+gunicorn
{% from "gunicorn/macros.jinja" import gunicorn %}
{{ gunicorn(name="sentry-web", user="sentry", venv="/home/sentry/venv",
            dir="/home/sentry", app="sentry.wsgi",
            workers=2) }}

# queue workers supervisord
sentry-workers:
  file.managed:
    - name: /etc/supervisor/conf.d/sentry-workers.conf
    - source: salt://monitoring/sentry/sentry-workers-supervisord.conf
    - watch_in:
      - service: supervisor
  supervisord.running:
    - require:
      - file: sentry-workers

{% from "backups/macros.jinja" import backup %}
{{ backup("sentry-db", "sentry", "pg_dump sentry") }}
