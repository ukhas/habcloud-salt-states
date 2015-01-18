include:
  - supervisor
  - nginx

saltbot:
  group.present:
    - system: false
  user.present:
    - home: /home/saltbot
    - gid_from_name: true

saltbot-code:
  git.latest:
    - name: https://github.com/adamgreig/saltbot.git
    - target: /home/saltbot/saltbot
    - force: true
    - rev: master
    - user: saltbot
    - always_fetch: true
    - watch_in:
      - supervisord: supervisor-saltbot

/home/saltbot/saltbot.yml:
  file.managed:
    - contents_pillar: saltbot
    - user: saltbot
    - group: saltbot
    - mode: 600

/home/saltbot/venv:
  virtualenv.managed:
    - no_site_packages: true
    - distribute: true
    - user: saltbot
    - requirements: /home/saltbot/saltbot/requirements.txt
    - watch:
      - git: saltbot-code

saltbot-install:
  pip.installed:
    - editable: /home/saltbot/saltbot
    - bin_env: /home/saltbot/venv
    - user: saltbot
    - upgrade: True
    - watch:
        - git: saltbot-code
    - require:
        - virtualenv: /home/saltbot/venv

/etc/supervisor/conf.d/saltbot.conf:
  file.managed:
    - source: salt://saltbot/supervisor.conf
    - watch_in:
      - service: supervisor

supervisor-saltbot:
  supervisord.running:
    - name: saltbot
    - require:
      - git: saltbot-code
      - file: /home/saltbot/saltbot.yml
      - file: /etc/supervisor/conf.d/saltbot.conf

/etc/nginx/conf.d/saltbot.conf:
  file.managed:
    - source: salt://saltbot/nginx-site.conf
    - template: jinja
