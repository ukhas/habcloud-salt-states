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

/etc/nginx/nginx.conf:
    file.managed:
        - source: salt://nginx/nginx.conf
        - require:
            - pkg: nginx

/etc/nginx/conf.d/catchall.conf:
    file.managed:
        - source: salt://nginx/site-catchall.conf
