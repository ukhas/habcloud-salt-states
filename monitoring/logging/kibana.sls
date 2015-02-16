include:
  - supervisor
  - nginx

kibana:
  group.present: []
  user.present:
    - home: /home/kibana
    - system: true
    - gid_from_name: true

{% set kibana_version "kibana-4.0.0-rc1-linux-x64" %}

kibana_download:
  archive.extracted:
    - name: /home/kibana
    - source: https://download.elasticsearch.org/kibana/kibana/{{ kibana_version }}.tar.gz
    - source_hash: sha256=212307c5b4f493a7118dcab8fc61fe7548f0c0537c0c6354f00d7e8e5e376ed0
    - archive_format: tar
    - archive_user: kibana

kibana_config:
  file.managed:
    - name: /home/kibana/{{ kibana_version }}/config/kibana.yml
    - source: salt://monitoring/logging/kibana.yml
    - user: kibana
    - require:
      - archive: kibana_download

kibana_supervisord:
  file.managed:
    - name: /etc/supervisor/conf.d/kibana.conf
    - source: salt://monitoring/logging/kibana_supervisord.conf
    - template: jinja
    - context:
      kibana_version: {{ kibana_version }}
    - watch_in:
      - service: supervisor
    - require:
      - file: kibana_config
  supervisord.running:
    - name: kibana

kibana-nginx-auth-basic:
  file.managed:
    - name: /etc/nginx/kibana_auth_basic
    - show_diff: false
    - contents_pillar: monitoring.kibana_auth_basic

kibana-nginx:
  file.managed:
    - name: /etc/nginx/conf.d/kibana.conf
    - source: salt://monitoring/logging/kibana_nginx.conf
    - template: jinja
    - watch_in:
      - service: nginx
    - require:
      - file: kibana-nginx-auth-basic
