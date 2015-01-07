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

    support.habhub.org:
      - exim.relay
      - apt_cache.server

    'not support.habhub.org':
      - match: compound
      - exim.satellite

    adamscratch.habhub.org:
      - habhub

#    'postgres*':
#        - postgres
