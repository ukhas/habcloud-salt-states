include:
  - backups
  - .influxdb
  - .grafana
  - .ukhasnet_influxdb

{% from "http/macros.jinja" import http %}

{{
  http(
    sites = {
      "grafana.ukhas.net": {
        "hostname": "grafana.ukhas.net",
        "aliases": [],
        "nginx_conf": "salt://ukhasnet/nginx/grafana.conf",
        "ssl": {"certificate": "grafana.ukhas.net"},
      },
    },
    http_10_host="grafana.ukhas.net",
    ssl = {"default_certificate": "grafana.ukhas.net"},
  )
}}
