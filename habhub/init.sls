include:
    - nginx

extend:
    nginx:
        service:
            - watch:
                - file: /etc/nginx/sites-available/habhub.org.conf
                - git: habhub-homepage
                - git: cusf-burst-calc

/etc/nginx/sites-available/habhub.org.conf:
    file.managed:
        - source: salt://habhub/nginx-site.conf
        - template: jinja

/etc/nginx/sites-enabled/habhub.org.conf:
    file.symlink:
        - target: /etc/nginx/sites-available/habhub.org.conf

habhub-homepage:
    git.latest:
        - name: https://github.com/ukhas/habhub-homepage.git
        - target: /srv/habhub-homepage
        - force: true
        - rev: master
        - always_fetch: true
        - submodules: true

cusf-burst-calc:
    git.latest:
        - name: https://github.com/ukhas/cusf-burst-calc.git
        - target: /srv/cusf-burst-calc
        - force: true
        - rev: master
        - always_fetch: true
        - submodules: true

# TODO
# files/
# notam_overlay
# zeusbot
