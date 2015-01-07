# dl-fldigi version check user
dfvc:
  group.present:
    - system: false
  user.present:
    - home: /home/dfvc
    - gid_from_name: true

# fetch dl-fldigi git repo, which contains update server source
dl-fldigi-code:
    git.latest:
        - name: https://github.com/jamescoxon/dl-fldigi.git
        - target: /home/dfvc/dl-fldigi
        - force: true
        - rev: master
        - user: dfvc
        - always_fetch: true

# create venv
/home/dfvc/venv:
  virtualenv.managed:
    - no_site_packages: true
    - distribute: true
    - user: dfvc
    - requirements: /home/dfvc/dl-fldigi/update_server/requirements.txt
    - require:
      - git: dl-fldigi-code

# install gunicorn into venv
gunicorn:
  pip.installed:
    - bin_env: /home/dfvc/venv
    - user: dfvc
    - require:
      - virtualenv: /home/dfvc/venv

# we use supervisor to run gunicorn
supervisor:
  pkg.installed: []
  service.running:
    - watch: 
    - file: /etc/supervisor/conf.d/dfvc.conf

# supervisor config file
/etc/supervisor/conf.d/dfvc.conf:
  file.managed:
    - source: salt://habhub/supervisor.conf

# restart supervised gunicorn process when dl-fldigi code updates
supervisor_dfvc:
  supervisord.running:
    - name: dfvc
    - watch:
      - git: dl-fldigi-code
