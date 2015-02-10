{% from "nginx/macros.jinja" import set_listen_addresses %}

varnish:
    pkg:
        - installed
    service.running:
        - enable: true
        - reload: true
        - require:
            - service: nginx
            - pkg: varnish
            - file: /etc/default/varnish
        - watch:
            - file: /etc/varnish/default.vcl

varnish-restart:
    service.running:
        - name: varnish
        - enable: true
        - reload: false
        - watch:
            - pkg: varnish
            - file: /etc/default/varnish

/etc/default/varnish:
    file.managed:
        - source: salt://varnish/etc-default-varnish
        - template: jinja
        - defaults:
            port: 80
            memory: 256m

/etc/varnish/default.vcl:
    file.managed:
        - source: salt://varnish/default.vcl
        - template: jinja

{{ set_listen_addresses(port=2080, use_x_forwarded=True) }}
