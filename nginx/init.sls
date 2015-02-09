nginx:
    # By default we use Debian's nginx, but individual VMs may need a more
    # modern version, so can copy this into their own states
    #pkgrepo.managed:
    #    - humanname: nginx stable
    #    - name: deb http://nginx.org/packages/debian/ wheezy nginx
    #    - dist: wheezy
    #    - file: /etc/apt/sources.list.d/nginx.list
    #    - key_url: http://nginx.org/keys/nginx_signing.key
    pkg:
        - installed
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

/etc/nginx/conf.d/catchall.conf:
    file.managed:
        - source: salt://nginx/site-catchall.conf

/etc/nginx/proxy_params:
    file.managed:
        - source: salt://nginx/proxy_params

/etc/nginx/listen_addresses:
    file.managed:
        - source: salt://nginx/listen_addresses
        - template: jinja
        - defaults:
              port: 80

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
