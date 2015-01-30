ntp:
    pkg.installed: []
    service.running:
      - enable: True
      - watch:
          - file: /etc/ntp.conf
      - require:
          - pkg: ntp

/etc/ntp.conf:
    file.managed:
      - source: salt://ntp/ntp.conf
      - template: jinja
      - defaults:
            upstream:
                # ntp `restrict` lines don't appear to be able to handle
                # DNS that resolves to multiple IP addresses correctly
                - ntp1.metronet-uk.com
                - ntp2.metronet-uk.com
            peers:
                {% if grains["host"] != "ceto" %}
                - ceto
                {% endif %}
                {% if grains["host"] != "phorcys" %}
                - phorcys
                {% endif %}
      - mode: 644
      - user: root
      - group: root
      - require:
          - pkg: ntp
