packages:
    pkg.installed:
      - names:
          - git
          - vim
          - htop
          - iotop
          - iftop
          - sysstat

# Unnecessary daemons listening on 0.0.0.0
purge-useless-nfs:
    pkg.purged:
      - name: nfs-common