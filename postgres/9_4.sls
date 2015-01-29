{% from "postgres/macros.jinja" import postgresql_setup %}
{{ postgresql_setup("9.4", True) }}
