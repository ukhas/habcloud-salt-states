include:
  - supervisor
  - python
  - .downloader

tawhiri:
    group.present: []
    user.present:
      - home: /srv/tawhiri
      - createhome: false
      - system: true
      - gid_from_name: true

/srv/tawhiri:
  file.directory:
    - dir_mode: 775
    - group: tawhiri
    - require:
      - group: tawhiri

# This is a bash script for no good reason. I couldn't get the virtualenv
# salt state module to work. 
tawhiri-installed:
  cmd.script:
    - name: "salt://tawhiri/install-tawhiri.sh"
    - creates: /srv/tawhiri/.installed-stamp
    - user: tawhiri
    - require:
      - file: /srv/tawhiri
      - user: tawhiri

imagemagick:
  pkg.installed: []

ruaumoko-dataset:
  cmd.script:
    - name: "salt://tawhiri/download-ruaumoko-dataset.sh"
    - creates: /srv/ruaumoko-dataset
    - require:
      - cmd: tawhiri-installed
      - pkg: imagemagick

{% from "http/macros.jinja" import http %}

{{
  http(
    sites = { 
        "predictor": {
            "hostname": "predictor.vm.habhub.org",
            "aliases": ["predict.cusf.co.uk"],
            "nginx_conf": "salt://tawhiri/nginx-site.conf",
        }   
    },  
    varnish = { 
        "http": true,
        "vcl": "salt://http/varnish/default.vcl",
        "memory": "1G"
    },  
    http_10_host="predictor"
  )
}}

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
    - watch_in:
      - service: supervisor
    - require:
      - cmd: tawhiri-installed
      - cmd: ruaumoko-dataset
      - file: /srv/tawhiri/gunicorn_cfg.py
      - service: tawhiri-api-run-dir
