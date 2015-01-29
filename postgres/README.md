# HabCloud PostgreSQL Salt States

These salt states set up PostgreSQL on a given VM but do _not_ configure 
databases or usernames. You can choose from (currently) PostgreSQL 9.1 or 9.4, 
with the latter installed automatically from the upstream PostgreSQL Debian 
repository.

# Usage

```
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
```


Or, for PostgreSQL 9.4:

```
include:
  - postgres.9_4
```

