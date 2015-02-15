rsyslog_repo:
  pkgrepo.managed:
    - humanname: rsyslog stable
    - name: deb http://debian.adiscon.com/v8-stable wheezy
    - dist: wheezy
    - file: /etc/apt/sources.list.d/rsyslog.list
    - keyid: AEF0CF8E
    - keyserver: keys.gnupg.net

rsyslog_pkgs:
  pkg.installed:
    - names:
      - rsyslog
      - rsyslog-relp
      - rsyslog-elasticsearch
    - require: pkgrepo: rsyslog_repo


