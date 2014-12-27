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

# This should be sufficient to install and enable
# Dist default produces no mail to root (as desired)
unattended-upgrades:
    pkg.installed
