nginx:
    pkgrepo.managed:
        - humanname: nginx stable
        - name: deb http://nginx.org/packages/debian/ wheezy nginx
        - dist: wheezy
        - file: /etc/apt/sources.list.d/nginx.list
        - key_url: http://nginx.org/keys/nginx_signing.key
    pkg:
        - installed
    service.running:
        - reload: true
        - enable: true
        - watch:
            - pkg: nginx
            - file: /etc/nginx/nginx.conf

/etc/nginx/nginx.conf:
    file.managed:
        - source: salt://nginx/nginx.conf
        - require:
            - pkg: nginx

distro-nginx-conf:
    file.absent:
      - names:
          - /etc/nginx/sites-available/default:
          - /etc/nginx/sites-enabled/default:
