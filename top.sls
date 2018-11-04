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

    habhub.vm.habhub.org:
      - habhub

    salt.vm.habhub.org:
      - saltbot

    ukhas.vm.habhub.org:
      - ukhas

    predictor.vm.habhub.org:
      - tawhiri.production

    predictor-hackathon.vm.habhub.org:
      - tawhiri.testing

    ukhasnet.vm.habhub.org:
      - ukhasnet
