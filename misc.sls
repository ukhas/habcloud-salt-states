misc-packages:
    pkg.installed:
      - names:
          - git
          - vim
          - htop
          - rsync
          - curl
          - iotop
          - iftop
          - netcat-openbsd
          - pv
          - tree
          - python-pip
          - python-virtualenv
          - build-essential
          - strace
          - ltrace
          - gdb
          - rsyslog-relp
          - apt-transport-https

# Unnecessary daemons listening on 0.0.0.0
purge-useless-nfs:
    pkg.purged:
      - name: nfs-common
