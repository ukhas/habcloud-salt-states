base:
    '*':
      - auth.ssh
      - auth.users
      - reqs
      - exim.satellite

    'ceto.habhub.org,phorcys.habhub.org':
      - match: list
      - ntp

    support:
      - exim.relay

#    'postgres*':
#        - postgres
