include:
  - http.php
  - backups

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
      - dir_mode: 755
      - require:
          - group: ukhas-dokuwiki

# create data and users.auth.php, and enforce their permissions,
# but not their contents
/srv/ukhas-data/data:
    file.directory:
      - user: ukhas-dokuwiki
      - group: sudo
      - dir_mode: 750
      - require:
          - user: ukhas-dokuwiki
          - file: /srv/ukhas-data

/srv/ukhas-data/users.auth.php:
    file.managed:
      - user: ukhas-dokuwiki
      - group: sudo
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
      - show_diff: false

/srv/ukhas-dokuwiki/conf/mime.local.conf:
    file.managed:
      - source: salt://ukhas/conf/mime.local.conf

/srv/ukhas-dokuwiki/conf/plugins.local.php:
    file.managed:
      - contents: "<?php"

{% from "http/php/macros.jinja" import php_pool %}
{{ php_pool("ukhas-dokuwiki", user="ukhas-dokuwiki") }}

{% from "http/macros.jinja" import http %}
{{
  http(
    sites = { 
        "ukhas": {
            "hostname": "ukhas.org.uk",
            "aliases": ["www.ukhas.org.uk", "wiki.ukhas.org.uk"],
            "nginx_conf": "salt://ukhas/nginx-site.conf",
            "ssl": {"certificate": "ukhas.org.uk"}
        }  
    },  
    ssl = { "default_certificate": "ukhas.org.uk" },
    varnish = {
        "http": false,
        "ssl": true,
        "vcl": "salt://ukhas/varnish.vcl",
        "memory": "1G"
    },
    http_10_host="ukhas"
  )
}}

{% from "backups/macros.jinja" import backup %}
{{ backup("ukhas-dokuwiki", "ukhas-dokuwiki",
          "tar c /srv/ukhas-data --exclude=/srv/ukhas-data/data/cache -P",
          "weekly") }}

/srv/ukhas-dokuwiki/incremental_helper.sh:
  file.managed:
    - makedirs: true
    - dirmode: 700
    - user: root
    - mode: 755
    - source: salt://ukhas/incremental_helper.sh
    - require_in:
       - cron: backup-ukhas-dokuwiki-incremental

salt://ukhas/initial_incremental_stamp.sh:
  cmd.script:
    - creates: /srv/ukhas-data/incremental-stamp
    - require:
       - user: ukhas-dokuwiki
    - require_in:
       - cron: backup-ukhas-dokuwiki-incremental

{{ backup("ukhas-dokuwiki-incremental", "ukhas-dokuwiki", "/srv/ukhas-dokuwiki/incremental_helper.sh", "daily") }}
