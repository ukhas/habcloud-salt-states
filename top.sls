base:
    '*':
      - auth.ssh
      - auth.users
      - reqs

    'ceto.habhub.org,phorcys.habhub.org':
      - match: list
      - ntp

    support.habhub.org:
      - exim.relay

    'not support.habhub.org':
      - match: compound
      - exim.satellite

#    'postgres*':
#        - postgres
