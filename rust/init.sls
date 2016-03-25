install-rust:
  cmd.script:
    - source: salt://rust/rustup.sh
    - creates: /usr/local/bin/rustc
