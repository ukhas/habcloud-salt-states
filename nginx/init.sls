nginx:
    pkgrepo.managed:
        - name: deb http://nginx.org/packages/debian/ wheezy nginx
        - file: /etc/apt/sources.list.d/nginx.list
        - key_url: http://nginx.org/keys/nginx_signing.key
    pkg:
        - installed
        - require:
            - pkgrepo: nginx
    service.running:
        - reload: true
        - enable: true
        - watch:
            - pkg: nginx
            - file: /etc/nginx/nginx.conf
            - file: /etc/nginx/conf.d/catchall.conf
            - file: /etc/nginx/proxy_params
            - file: /etc/nginx/listen_addresses

/etc/nginx/nginx.conf:
    file.managed:
        - source: salt://nginx/nginx.conf
        - require:
            - pkg: nginx

/etc/nginx/proxy_params:
    file.managed:
        - source: salt://nginx/proxy_params

/etc/nginx/listen_addresses:
    file.managed:
        - source: salt://nginx/listen_addresses
        - template: jinja
        - defaults:
              port: 80
              ssl: false

/etc/nginx/dhparam.pem:
    file.managed:
        - source: salt://nginx/dhparam.pem

/etc/nginx/startssl.pem:
    file.managed:
        - source: salt://nginx/startssl.pem

/etc/nginx/conf.d/catchall.conf:
    file.managed:
        - source: salt://nginx/site-catchall.conf
        - template: jinja
        - defaults:
              http_port: 80
              ssl: null

/srv/nginx-common/robots.txt:
  file.managed:
    - source: salt://nginx/robots.txt
    - mode: 644
    - makedirs: true
    - dir_mode: 755

/srv/nginx-common/favicon.ico:
  file.managed:
    - source: salt://nginx/favicon.ico
    - mode: 644
    - makedirs: true
    - dir_mode: 755

distro-nginx-sites:
  file.absent:
    - names:
        - /etc/nginx/sites-available
        - /etc/nginx/sites-enabled
