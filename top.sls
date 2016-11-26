base:
    '*':
      - misc
      - unattended_upgrades
      - auth.ssh
      - auth.users
      - apt_cache.client
      - sysstat
      - ntp

    support.vm.habhub.org:
      - exim.relay
      - apt_cache.server

    '* and not support.vm.habhub.org':
      - match: compound
      - exim.satellite

    '* and not monitoring.vm.habhub.org':
      - match: compound
      - monitoring.client

    habhub.vm.habhub.org:
      - habhub

    salt.vm.habhub.org:
      - saltbot

    adamscratch.vm.habhub.org:
      - adamscratch

    ukhas.vm.habhub.org:
      - ukhas

#    monitoring.vm.habhub.org:
#      - monitoring

    predictor.vm.habhub.org:
      - tawhiri.downloader

    predictor-hackathon.vm.habhub.org:
      - http/test/hackathon

    ukhasnet.vm.habhub.org:
      - ukhasnet
