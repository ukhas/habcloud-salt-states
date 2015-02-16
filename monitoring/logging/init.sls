### rsyslog

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

rsyslog:
  service.running: []


/etc/rsyslog.d/habcloud-server.conf:
  file.managed:
    - source: salt://monitoring/logging/rsyslog-server.conf
    - watch_in:
      - service: rsyslog

### elasticsearch

elasticsearch_repo:
  pkgrepo.managed:
    - name: deb http://packages.elasticsearch.org/elasticsearch/1.4/debian stable main
    - file: /etc/apt/sources.list.d/elasticsearch.list
    - keyid: D88E42B4
    - keyserver: pgp.mit.edu

openjdk-7-jre-headless:
  pkg.installed: []

elasticsearch:
  pkg.installed:
    - require:
      - pkgrepo: elasticsearch_repo
  service.running: []

/etc/elasticsearch/elasticsearch.yml:
  file.managed:
    - source: salt://monitoring/logging/elasticsearch.yml
    - watch_in:
      - service: elasticsearch
