# # dl-fldigi version check server
# This server is a Python and Flask web app that is served by gunicorn,
# with process management by supervisor and front end HTTP by nginx.
#
# It is hit up by dl-fldigi client software to check if a new version has
# been released.

include:
  - supervisor

{% from "gunicorn/macros.jinja" import gunicorn %}

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
    - watch:
      - git: dl-fldigi-code

# install gunicorn into venv
gunicorn_dfvc:
  pip.installed:
    - name: gunicorn
    - bin_env: /home/dfvc/venv
    - user: dfvc
    - require:
      - virtualenv: /home/dfvc/venv

# supervisor+gunicorn
{{ gunicorn(name="dfvc", user="dfvc", venv="/home/dfvc/venv",
            dir="/home/dfvc/dl-fldigi/update_server", app="app:app",
            workers=2) }}

# restart supervised gunicorn process when dl-fldigi code updates
supervisor_dfvc:
  supervisord.running:
    - name: dfvc
    - watch:
      - git: dl-fldigi-code
