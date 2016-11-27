include:
  - .common
  - .gunicorn

tawhiri-code:
  git.latest:
    - name: https://github.com/cuspaceflight/tawhiri
    - target: /srv/tawhiri/src
    - force: true
    - rev: master
    - user: tawhiri
    - always_fetch: true
    - require:
      - file: /srv/tawhiri

cython-installed:
  cmd.run:
    - name: "/srv/tawhiri/bin/pip3 install Cython"
    - creates: /srv/tawhiri/.cython-installed-stamp
    - user: tawhiri
    - require:
      - file: /srv/tawhiri
      - user: tawhiri

tawhiri-installed:
  cmd.run:
    - name: "/srv/tawhiri/bin/python3 /srv/tawhiri/src/setup.py develop"
    - creates: /srv/tawhiri/.develop-setup-stamp
    - user: tawhiri
    - require:
      - user: tawhiri
      - cmd: cython-installed
      - git: tawhiri-code
    - watch:
      - git: tawhiri-code

{% from "http/macros.jinja" import http %}

{{
  http(
    sites = { 
        "predictor-hackathon": {
            "hostname": "predictor-hackathon.vm.habhub.org",
            "aliases": [],
            "nginx_conf": "salt://tawhiri/nginx-site.conf",
        }   
    },  
    http_10_host="predictor-hackathon"
  )
}}
