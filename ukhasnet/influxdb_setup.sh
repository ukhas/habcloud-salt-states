#!/bin/bash
{% set admin_password = pillar['ukhasnet']['influxdb']['admin_password'] %}
{% set users = pillar['ukhasnet']['influxdb']['users'] %}
{% set databases = pillar['ukhasnet']['influxdb']['databases'] %}

# Create admin user
influxdb -username admin -password {{ admin_password }} \
    -execute "CREATE USER admin WITH PASSWORD '{{ admin_password }}' WITH ALL PRIVILEGES"

# Create each database
{% for database in databases %}
influxdb -username admin -password {{ admin_password }} \
    -execute "CREATE DATABASE {{ database }}"
{% endfor %}

# Create each non-admin user and grant them permissions
{% for user, data in users.items() %}
influxdb -username admin -password {{ admin_password }} \
    -execute "CREATE USER {{ user }} WITH PASSWORD '{{ data.password }}'"

{% for database, level in data.grants.items() %}
influxdb -username admin -password {{ admin_password }} \
    -execute "GRANT {{ level }} ON {{ database }} TO {{ user }}"
{% endfor %}

{% endfor %}
