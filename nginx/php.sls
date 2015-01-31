php5-fpm:
    pkg.installed:
        - names:
            - php5-cli
            - php5-fpm
    service.running:
        - name: php5-fpm
        - reload: true
        - enable: true
        - watch:
            - pkg: php5-fpm
            - file: /etc/php5/fpm/php.ini
            - file: /etc/php5/fpm/php-fpm.conf


/etc/php5/conf.d/cgi-fix-pathinfo.conf:
    file.managed:
        - source: salt://nginx/cgi-fix-pathinfo.conf
        - require:
            - pkg: php5-fpm

{% macro php_pool(name, user, max_servers=30, start_servers=10,
                  min_spare=5, max_spare=10) %}
/etc/php5/fpm/pool.d/{{ name }}.conf:
    file.managed:
        - source: salt://nginx/php-fpm-pool.conf
        - defaults:
            - name: {{ name }}
            - user: {{ user }}
            - max_servers: {{ max_servers }}
            - start_servers: {{ start_servers }}
            - min_spare: {{ min_spare }}
            - max_spare: {{ max_spare }}
        - watch_in:
            - service: php5-fpm
{% endmacro %}
