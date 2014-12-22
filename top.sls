base:
    '*':
      - auth.ssh
      - auth.users
      - reqs
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

#    'postgres*':
#        - postgres
