{% from "backups/macros.jinja" import backup %}
{{ backup("test_backup", "wget -q -O- http://pastie.org/pastes/9872384/download") }}
