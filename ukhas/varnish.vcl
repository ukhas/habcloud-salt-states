{% extends "varnish/default.vcl" %}

{% macro always_cache_condition() %}
    (req.url ~ "^(/_media/|/lib/exe/(js|css).php)")
{% endmacro %}

{% macro authed_condition() %}
    (    req.http.Authorization
     || (req.http.cookie !~ "DOKUWIKI_AUTH") )
{% endmacro %}

{% block vcl_recv_inner %}
    if ({{ always_cache_condition() }}) {
        /* If it's a /_media/ URL, strip all cookies to make it an
           unauthed request (if it was); it then should be safe to
           cache & return (since e.g., login reqs are done via POST) */
        /* Remove /all/ cookies, including session */
        remove req.http.cookie;
        return (lookup);
        /* XXX: does this produce lots of useless PHP sessions? */
    } else if ({{ authed_condition() }}) {
        /* User is logged in. Response will contain references to the user,
           could contain, 'Set-Cookie' headers that log the user out (this
           will even happen on a GET request...), ... */
        return (pass);
    } else {
        /* Unauthed user looking at page, etc...
           Remove DOKU_PREFS, DOKUWIKI cookies (preferences, breadcrumbs, ...) */
        remove req.http.cookie;
        return (lookup);
    }
{% endblock %}

{% block vcl_fetch %}
sub vcl_fetch {
    if ({{ always_cache_condition() }} || !{{ authed_condition() }}) {
        set beresp.ttl = 300s;
        remove beresp.http.Set-Cookie;
    }

    /* We'll be in pass mode if vcl_recv decided, so it won't be inserted
       into the cache. */
    return (deliver);
}
{% endblock %}
