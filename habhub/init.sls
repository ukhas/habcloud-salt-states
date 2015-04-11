include:
    - .dl_fldigi_version_check

{% from "http/macros.jinja" import http %}

{{
  http(
    sites = { 
        "habhub": {
            "hostname": "habhub.org",
            "aliases": ["www.habhub.org"], 
            "nginx_conf": "salt://habhub/nginx/habhub.conf"
        },
        "saltbotproxy": {
            "hostname": "saltbot.habhub.org",
            "aliases": [], 
            "nginx_conf": "salt://habhub/nginx/saltbot-proxy.conf"
        }   
    },  
    http_10_host="habhub"
  )
}}

habhub-homepage:
    git.latest:
        - name: https://github.com/ukhas/habhub-homepage.git
        - target: /srv/habhub-homepage
        - force: true
        - rev: master
        - always_fetch: true
        - submodules: true
        - watch_in:
          - service: nginx

cusf-burst-calc:
    git.latest:
        - name: https://github.com/ukhas/cusf-burst-calc.git
        - target: /srv/cusf-burst-calc
        - force: true
        - rev: master
        - always_fetch: true
        - submodules: true
        - watch_in:
          - service: nginx
