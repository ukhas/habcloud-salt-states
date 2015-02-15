misc-packages:
    pkg.installed:
      - names:
          - git
          - vim
          - htop
          - rsync
          - iotop
          - iftop
          - sysstat
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

# Unnecessary daemons listening on 0.0.0.0
purge-useless-nfs:
    pkg.purged:
      - name: nfs-common
