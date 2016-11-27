squid3:
    pkg:
      - name: squid3
      - installed

    service.running:
      - enable: True
      - watch:
          - file: /etc/squid3/squid.conf
      - require:
          - pkg: squid3

/etc/squid3/archive_mirrors.txt:
  file.managed:
    - source: salt://apt_cache/archive_mirrors.txt
    - mode: 644
    - user: root
    - group: root

/etc/squid3/squid.conf:
    file.managed:
      - source: salt://apt_cache/squid.conf
      - mode: 644
      - user: root
      - group: root
      - require:
          - pkg: squid3
          - file: /etc/squid3/archive_mirrors.txt

extend:
    /etc/apt/apt.conf.d/10proxy:
        file.managed:
          - require:
              - service: squid3
