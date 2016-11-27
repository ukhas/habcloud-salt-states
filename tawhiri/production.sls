include:
  - .common
  - .downloader
  - .gunicorn

tawhiri-installed:
  cmd.run:
    - name: "/srv/tawhiri/bin/pip3 install Tawhiri==0.2.0"
    - creates: /srv/tawhiri/lib/python3.5/site-packages/tawhiri/
    - user: tawhiri
    - require:
      - file: /srv/tawhiri
      - user: tawhiri

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
