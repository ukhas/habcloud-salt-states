include:
    - nginx
    - nginx.php

{% from "nginx/php-macros.jinja" import php_pool %}

/etc/nginx/conf.d/scratch.conf:
    file.managed:
        - source: salt://scratch/nginx-site.conf
        - template: jinja
        - watch_in:
            - service: nginx

{{ php_pool("test", user="www-data") }}
