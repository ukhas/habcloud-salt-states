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
  group.present: []
  user.present:
    - home: /home/dfvc
    - system: true
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
    - watch_in:
      - supervisord: supervisor-dfvc

# create venv
/home/dfvc/venv:
  virtualenv.managed:
    - distribute: true
    - user: dfvc
    - requirements: /home/dfvc/dl-fldigi/update_server/requirements.txt
    - watch:
      - git: dl-fldigi-code

# supervisor+gunicorn
{% from "http/gunicorn/macros.jinja" import gunicorn %}
{{ gunicorn(name="dfvc", user="dfvc", venv="/home/dfvc/venv",
            dir="/home/dfvc/dl-fldigi/update_server", app="app:app",
            workers=2) }}
