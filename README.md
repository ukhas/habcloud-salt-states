# HabCloud Salt States

## Notes

 - We use `show_changes: false` on `file.managed` states where the file may
   contain secrets (via pillar)

