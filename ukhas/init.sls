include:
    - nginx
    - nginx.php

{% from "nginx/php-macros.jinja" import php_pool %}

ukhas-dokuwiki:
    group.present: []
    user.present:
      - home: /srv/ukhas-dokuwiki
      - createhome: false
      - system: true
      - gid_from_name: true

salt://ukhas/install_dokuwiki.sh:
    cmd.script:
      - creates: /srv/ukhas-dokuwiki

/srv/ukhas-data:
    file.directory:
      - user: root
      - group: ukhas-dokuwiki
      - dir_mode: 750
      - require:
          - group: ukhas-dokuwiki

# create data and users.auth.php, and enforce their permissions,
# but not their contents
/srv/ukhas-data/data:
    file.directory:
      - user: ukhas-dokuwiki
      - group: ukhas-dokuwiki
      - dir_mode: 750
      - require:
          - user: ukhas-dokuwiki
          - file: /srv/ukhas-data

/srv/ukhas-data/users.auth.php:
    file.managed:
      - user: ukhas-dokuwiki
      - group: ukhas-dokuwiki
      - mode: 640
      - require:
          - user: ukhas-dokuwiki
          - file: /srv/ukhas-data

/srv/ukhas-dokuwiki/conf/acl.auth.php:
    file.managed:
      - source: salt://ukhas/conf/acl.auth.php

/srv/ukhas-dokuwiki/conf/local.php:
    file.managed:
      - source: salt://ukhas/conf/local.php

/srv/ukhas-dokuwiki/conf/local.keys.php:
    file.managed:
      - source: salt://ukhas/conf/local.keys.php
      - template: jinja
      - show_changes: false

/srv/ukhas-dokuwiki/conf/mime.local.conf:
    file.managed:
      - source: salt://ukhas/conf/mime.local.conf

{{ php_pool("ukhas-dokuwiki", user="ukhas-dokuwiki") }}

/etc/nginx/conf.d/ukhas.conf:
    file.managed:
      - source: salt://ukhas/nginx-site.conf
      - template: jinja
      - watch_in:
          - service: nginx
