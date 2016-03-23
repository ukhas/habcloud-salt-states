include:
  - backups

grafana:
  pkgrepo.managed:
    - name: deb https://packagecloud.io/grafana/stable/debian/ wheezy main
    - file: /etc/apt/sources.list.d/grafana.list
    - key_url: https://packagecloud.io/gpg.key
  pkg.installed: []
  service.running:
    - name: grafana-server
    - reload: true
    - enable: true

# TODO: Ship a config file that restricts ports to localhsot only,
# sets an admin username and password, maybe other things, add to watch list

# TODO: Add Grafana database backups
# {% from "backups/macros.jinja" import backup %}
# {{ backup("ukhasnet-grafana", "username", "cmd") }}
