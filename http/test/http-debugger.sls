/usr/local/bin/habcloud-http-probe:
  file.managed:
    - mode: 755
    - source: salt://http/test/probe/client.py

include:
  - supervisor

/srv/probe-backend:
  file.directory

# For probe-client.
python3:
  pkg.installed

# We run the server as python2 because it's a gigantic PITA to do
# python3 virtualenvs (at the time of writing)
/srv/probe-backend/venv:
  file.directory:
    - user: www-data
  virtualenv.managed:
    - distribute: true
    - user: www-data
    - requirements: salt://http/test/probe/backend-requirements.txt
    - require:
       - file: /srv/probe-backend/venv
    - watch_in:
       - supervisor: supervisor-probe

/srv/probe-backend/backend.py:
  file.managed:
    - source: salt://http/test/probe/backend.py
    - user: www-data
    - watch_in:
       - supervisor: supervisor-probe

{% from "http/gunicorn/macros.jinja" import gunicorn %}
{{ gunicorn(name="probe", user="www-data", venv="/srv/probe-backend/venv",
            dir="/srv/probe-backend", app="backend:app_proxyfixed",
            workers=2) }}


{% from "http/macros.jinja" import http %}
{{
  http(
    sites = { 
        "scratch": {
            "hostname": "scratch.vm.habhub.org",
            "aliases": [],
            "nginx_conf": "salt://http/test/probe/nginx-site.conf",
            "ssl": {"certificate": "scratch.vm.habhub.org"}
        }  
    },  
    ssl = { "default_certificate": "scratch.vm.habhub.org" },
    varnish = { "http": false, "ssl": true, "vcl": none, "memory": "128m" },
    http_10_host="scratch"
  )
}}
