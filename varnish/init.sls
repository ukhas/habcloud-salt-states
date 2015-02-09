varnish:
    pkg:
        - installed
    service.running:
        - reload: true
        - enable: true
        - require:
            - service: nginx
        - watch:
            - pkg: varnish
            - file: /etc/varnish/default.vcl

/etc/varnish/default.vcl:
    file.managed:
        - source: salt://varnish/default.vcl
        - template: jinja

extend:
    /etc/nginx/listen_addresses:
        file.managed:
            - defaults:
                  port: 2080
