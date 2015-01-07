# # dl-fldigi version check server
# This server is a Python and Flask web app that is served by gunicorn,
# with process management by supervisor and front end HTTP by nginx.
#
# It is hit up by dl-fldigi client software to check if a new version has
# been released.

include:
  - supervisor

# dl-fldigi version check user
dfvc:
  group.present:
    - system: false
  user.present:
    - home: /home/dfvc
    - gid_from_name: true

# fetch dl-fldigi git repo, which contains update server source
dl-fldigi-code:
    git.latest:
        - name: https://github.com/ukhas/dl-fldigi.git
        - target: /home/dfvc/dl-fldigi
        - force: true
        - rev: master
        - user: dfvc
        - always_fetch: true

# create venv
/home/dfvc/venv:
  virtualenv.managed:
    - no_site_packages: true
    - distribute: true
    - user: dfvc
    - requirements: /home/dfvc/dl-fldigi/update_server/requirements.txt
    - require:
      - git: dl-fldigi-code

# install gunicorn into venv
gunicorn:
  pip.installed:
    - bin_env: /home/dfvc/venv
    - user: dfvc
    - require:
      - virtualenv: /home/dfvc/venv

# supervisor config file
/etc/supervisor/conf.d/dfvc.conf:
  file.managed:
    - source: salt://supervisor/gunicorn-template.conf
    - template: jinja
    - context:
        name: dfvc
        venv_path: /home/dfvc/venv
        app: "app:app"
        port: 8001
        num_workers: 2
        program_dir: /home/dfvc/dl-fldigi/update_server
        user: dfvc
extend:
  supervisor:
    service:
      - watch: 
        - file: /etc/supervisor/conf.d/dfvc.conf

# restart supervised gunicorn process when dl-fldigi code updates
supervisor_dfvc:
  supervisord.running:
    - name: dfvc
    - watch:
      - git: dl-fldigi-code
