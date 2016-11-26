/usr/local/src/Python-3.5.2.tgz:
  file.managed:
    - source: "https://www.python.org/ftp/python/3.5.2/Python-3.5.2.tgz"
    - source_hash: sha256=1524b840e42cf3b909e8f8df67c1724012c7dc7f9d076d4feef2d3eff031e8a0

python3-build-deps:
    pkg.installed:
      - names:
          - libreadline-dev
          - libncursesw5-dev
          - zlib1g-dev
          - libdb-dev
          - libgdbm-dev
          - libssl-dev
          - libbz2-dev
          - sharutils
          - libexpat1-dev
          - libsqlite3-dev
          - libffi-dev
          - libfreetype6-dev
          - libpng-dev

python3-installed:
  cmd.script:
    - name: "salt://python/install-python3.5.sh"
    - creates: /usr/local/src/Python-3.5.2/.installed-stamp
    - require:
      - file: /usr/local/src/Python-3.5.2.tgz
      - pkg: python3-build-deps
