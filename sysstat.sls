sysstat:
  pkg.installed: []
  service.running:
    - enable: True
    - watch:
        - file: /etc/default/sysstat
    - require:
        - pkg: sysstat

/etc/default/sysstat:
  file.managed:
    - contents: 'ENABLED="true"'
