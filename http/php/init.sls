php5-fpm:
    pkg.installed:
        - names:
            - php5-cli
            - php5-fpm
            - php-apc
    service.running:
        - name: php5-fpm
        - reload: true
        - enable: true
        - watch:
            - pkg: php5-fpm
            - file: /etc/php5/conf.d/cgi-fix-pathinfo.ini

/etc/php5/conf.d/cgi-fix-pathinfo.ini:
    file.managed:
        - contents: "cgi.fix_pathinfo=0\n"
        - require:
            - pkg: php5-fpm

/etc/php5/fpm/pool.d/www.conf:
    file.absent
