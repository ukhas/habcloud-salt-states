include:
  - nginx
  - backups
  - .sentry
  - .logging

{% from "nginx/macros.jinja" import deploy_ssl_files, set_listen_addresses %}
{{ deploy_ssl_files("monitoring.vm.habhub.org") }}
{{ set_listen_addresses(ssl={"certificate": "monitoring.vm.habhub.org"}) }}
