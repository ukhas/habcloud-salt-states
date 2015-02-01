{% from "backups/macros.jinja" import backup %}
{{ backup("test_backup",
          "adam",
          "wget -q -O- \"http://pastie.org/pastes/9872384/download\"") }}

include:
  - postgres.9_1

adams_group:
  postgres_group.present:
    - inherit: true

adam:
  postgres_user.present:
    - groups: adams_group

adams_db:
  postgres_database.present:
    - owner: adams_group
    - encoding: UTF8
    - lc_collate: en_GB.UTF-8
    - lc_ctype: en_GB.UTF-8
