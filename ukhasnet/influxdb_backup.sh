#!/bin/bash
set -eu

{% set admin_password = pillar['ukhasnet']['influxdb']['admin_password'] %}
{% set databases = pillar['ukhasnet']['influxdb']['databases'] %}

mkdir -p /tmp/influx-backups
chmod 700 /tmp/influx-backups

{% for database in databases %}
influxd backup -database {{ database }} /tmp/influx-backups
{% endfor %}

tar cf - /tmp/influx-backups

rm -rf /tmp/influx-backups
