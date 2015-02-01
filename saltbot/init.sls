include:
  - supervisor
  - nginx
  - postgres.9_1

saltbot:
  group.present: []
  user.present:
    - home: /home/saltbot
    - system: true
    - gid_from_name: true
  postgres_user.present: []
  postgres_database.present:
    - owner: postgres

saltbot-code:
  git.latest:
    - name: https://github.com/adamgreig/saltbot.git
    - target: /home/saltbot/saltbot
    - force: true
    - rev: master
    - user: saltbot
    - always_fetch: true

python-psycopg2:
  pkg.installed

/home/saltbot/saltbot.yml:
  file.managed:
    - contents_pillar: saltbot
    - user: saltbot
    - group: saltbot
    - mode: 600

/home/saltbot/venv:
  virtualenv.managed:
    - system_site_packages: true
    - distribute: true
    - user: saltbot
    - requirements: /home/saltbot/saltbot/requirements.txt
    - watch:
      - git: saltbot-code

saltbot-install:
  cmd.wait:
    - name: /home/saltbot/venv/bin/python setup.py develop
    - user: saltbot
    - group: saltbot
    - cwd: /home/saltbot/saltbot
    - watch:
        - git: saltbot-code
    - require:
        - virtualenv: /home/saltbot/venv

saltbot-tables:
  cmd.wait:
    - name: /home/saltbot/venv/bin/saltbot-createtables /home/saltbot/saltbot.yml
    - user: saltbot
    - group: saltbot
    - cwd: /home/saltbot
    - watch:
      - cmd: saltbot-install

/etc/supervisor/conf.d/saltbot.conf:
  file.managed:
    - source: salt://saltbot/supervisor.conf
    - watch_in:
      - service: supervisor

supervisor-saltbot:
  supervisord.running:
    - name: saltbot
    - watch:
      - git: saltbot-code
      - file: /home/saltbot/saltbot.yml
      - file: /etc/supervisor/conf.d/saltbot.conf

/etc/nginx/conf.d/saltbot.conf:
  file.managed:
    - source: salt://saltbot/nginx-site.conf
    - template: jinja
    - watch_in:
      - service: nginx
