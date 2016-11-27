include:
  - supervisor
 
gunicorn-installed:
  cmd.run:
    - name: "/srv/tawhiri/bin/pip3 install gunicorn"
    - user: tawhiri
    - creates: /srv/tawhiri/.gunicorn-installed
    - require:
      - cmd: tawhiri-venv

/srv/tawhiri/gunicorn_cfg.py:
  file.managed:
    - source: "salt://tawhiri/gunicorn_cfg.py"
    - user: tawhiri

/etc/init.d/tawhiri-api-run-dir:
  file.managed:
    - source: salt://tawhiri/init.d-tawhiri-api-run-dir
    - mode: 755

tawhiri-api-run-dir:
  service.running:
    - enable: True
    - require:
      - file: /etc/init.d/tawhiri-api-run-dir

/etc/supervisor/conf.d/tawhiri-api.conf:
  file.managed:
    - source: salt://tawhiri/tawhiri-api.supervisor.conf
    - require:
      - cmd: tawhiri-installed
      - cmd: ruaumoko-dataset
      - file: /srv/tawhiri/gunicorn_cfg.py
      - service: tawhiri-api-run-dir

supervisor-tawhiri-api:
  supervisord.running:
    - name: tawhiri-api
    - update: true
    - require:
      - file: /etc/supervisor/conf.d/tawhiri-api.conf
    - watch:
      - file: /etc/supervisor/conf.d/tawhiri-api.conf
      - cmd: tawhiri-installed
