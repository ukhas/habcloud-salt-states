# HabCloud Salt States

## Notes

 - We use `show_changes: false` on `file.managed` states where the file may
   contain secrets (via pillar)

 - The `default_server` is the nginx `server` block that is matched if no
   other server block is matched. This term is used in `listen_addresses`
   and `site-catchall.conf`. It redirects people to `habhub.org`.
   Other states don't need to touch this.
   
 - The `default_host` is the `server` block that handles requests that
   do not have a `Host` header (i.e., `HTTP/1.0` clients). This is
   used in `site-template.conf`, and so should be set to true in
   your `nginx-site.conf`.
