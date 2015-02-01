include:
    - nginx
    - nginx.php

/etc/nginx/conf.d/scratch.conf
    file.managed:
        - source: salt://scratch/nginx-site.conf
        - template: jinja

{{ php_pool("test", user="www-data") }}
