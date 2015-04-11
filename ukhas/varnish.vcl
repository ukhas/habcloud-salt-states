{% extends "varnish/default.vcl" %}

{% macro always_cache_condition() %}
    (req.url ~ "^(/_media/|/lib/exe/(js|css).php)")
{% endmacro %}

{% macro authed_condition() %}
    (    req.http.Authorization
     || (req.http.cookie ~ "DOKUWIKI_AUTH") )
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
           and could contain 'Set-Cookie' headers that log the user out (this
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
    if (req.request != "GET" && req.request != "HEAD") {
        /* I don't think setting the TTL is necessary,
           since we should be in pass mode.
           This block /is/ necessary, or we delete Set-Cookie from
           responses to POSTs. */
        set beresp.ttl = 0s;
        return (hit_for_pass);
    } else if ({{ always_cache_condition() }} || !{{ authed_condition() }}) {
        set beresp.ttl = 300s;
        remove beresp.http.Set-Cookie;
        return (deliver);
    } else {
        set beresp.ttl = 0s;    /* ditto */
        return (hit_for_pass);
    }
}
{% endblock %}
