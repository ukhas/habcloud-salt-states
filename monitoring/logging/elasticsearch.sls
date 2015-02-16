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
