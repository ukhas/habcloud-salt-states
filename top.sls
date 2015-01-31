base:
    '*':
      - misc
      - unattended_upgrades
      - auth.ssh
      - auth.users
      - apt_cache.client

    'ceto.habhub.org,phorcys.habhub.org':
      - match: list
      - ntp

    support.vm.habhub.org:
      - exim.relay
      - apt_cache.server

    '* and not support.vm.habhub.org':
      - match: compound
      - exim.satellite

    habhub.vm.habhub.org:
      - habhub

    salt.vm.habhub.org:
      - saltbot

    adamscratch.vm.habhub.org:
      - backups
      - adamscratch

    scratch.vm.habhub.org:
      - ntp
