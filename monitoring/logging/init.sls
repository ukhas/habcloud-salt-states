rsyslog_repo:
  pkgrepo.managed:
    - name: deb http://debian.adiscon.com/v8-stable wheezy/
    - file: /etc/apt/sources.list.d/rsyslog.list
    - keyid: AEF0CF8E
    - keyserver: keys.gnupg.net

rsyslog_pkgs:
  pkg.installed:
    - names:
      - rsyslog
      - rsyslog-relp
      - rsyslog-elasticsearch
    - require:
      - pkgrepo: rsyslog_repo

elasticsearch_repo:
  pkgrepo.managed:
    - name: deb http://packages.elasticsearch.org/elasticsearch/1.4/debian stable main
    - file: /etc/apt/sources.list.d/elasticsearch.list
    - keyid: D88E42B4
    - keyserver: pgp.mit.edu

elasticsearch:
  pkg.installed:
    - require:
      - pkgrepo: elasticsearch_repo
  service.running: []

rsyslog:
  service.running: []


/etc/rsyslog.d/habcloud-server.conf:
  file.managed:
    - source: salt://monitoring/logging/rsyslog-server.conf
    - watch_in:
      - service: rsyslog
