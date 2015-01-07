include:
    - nginx

extend:
    nginx:
        service:
            - watch:
                - file: /etc/nginx/sites-enabled/www.habhub.org.conf

/etc/nginx/sites-available/www.habhub.org.conf:
    file.managed:
        - source: salt://habhub/nginx-site.conf        

/etc/nginx/sites-enabled/www.habhub.org.conf:
    file.symlink:
        - target: /etc/nginx/sites-available/www.habhub.org.conf

habhub-homepage:
    git.latest:
        - name: https://github.com/ukhas/habhub-homepage.git
        - target: /srv/habhub-homepage
        - force: true
        - rev: master
        - user: www-data
        - always_fetch: True

cusf-burst-calc:
    git.latest:
        - name: https://github.com/ukhas/cusf-burst-calc.git
        - target: /srv/cusf-burst-calc
        - force: true
        - rev: master
        - user: www-data
        - always_fetch: True

# TODO
# files/
# notam_overlay
# zeusbot
