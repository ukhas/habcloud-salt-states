include:
    - nginx
    - .dl_fldigi_version_check

/etc/nginx/conf.d/habhub.org.conf:
    file.managed:
        - source: salt://habhub/nginx-site.conf
        - template: jinja
        - watch_in:
            - service: nginx

habhub-homepage:
    git.latest:
        - name: https://github.com/ukhas/habhub-homepage.git
        - target: /srv/habhub-homepage
        - force: true
        - rev: master
        - always_fetch: true
        - submodules: true
        - watch_in:
          - service: nginx

cusf-burst-calc:
    git.latest:
        - name: https://github.com/ukhas/cusf-burst-calc.git
        - target: /srv/cusf-burst-calc
        - force: true
        - rev: master
        - always_fetch: true
        - submodules: true
        - watch_in:
          - service: nginx
