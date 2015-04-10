import std;

{% block backends %}
backend nginx_http_back {
    .host = "127.0.0.1";
    .port = "{{ ports.nginx_http_back }}";
}

backend nginx_ssl_back {
    .host = "127.0.0.1";
    .port = "{{ ports.nginx_ssl_back }}";
}
{% endblock %}

acl local {
    "127.0.0.1";
    "::1";
}

{% block vcl_recv %}
sub vcl_recv {
    if (server.port == {{ ports.http_front }}) {
        {# Some sort of weird staged computation going on here.
           If forwarded_from is none, then this should compile to a short
           circuit false. We have to provide '127.0.0.2' in the client.ip test
           because it tries to parse it as an hostname/address. #}
        if (    {{ (forwarded_from is not none)|lower }}
             && client.ip == "{{ forwarded_from or '127.0.0.2' }}"
             && req.http.X-Forwarded-For) {
            {# preserve X-Forwarded-For & X-Forwarded-Proto #}
        } else {
            set req.http.X-Forwarded-For = client.ip;
            set req.http.X-Forwarded-Proto = "http";
        }
        set req.backend = nginx_http_back;
    } else if (server.port == {{ ports.varnish_back }}) {
        if (client.ip !~ local) {
            error 403 "Forbidden";
        }
        set req.backend = nginx_ssl_back;
        {# preserve X-Forwarded-For and X-Forwarded-Proto headers,
           though note that nginx bases any SSL vs non-SSL decisions on the
           backend port the connection was received on anyway;
           it is choosing the correct backend that matters #}
        if (!req.http.X-Forwarded-For) {
            set req.http.X-Forwarded-For = client.ip;
            set req.http.X-Forwarded-Proto = "http";
        }
    }
    {# By this point, req.http.X-Forwarded-For is set to the true
       client IP address (hopefully) #}
    std.log("X-Real-IP: " + req.http.X-Forwarded-For);
    remove req.http.X-Forwarded-Host;

    if (req.http.host == "{{ status_site_host }}") {
        {# status site #}
        return (pass);
    }

    if (req.request != "GET" &&
        req.request != "HEAD" &&
        req.request != "PUT" &&
        req.request != "POST" &&
        req.request != "TRACE" &&
        req.request != "OPTIONS" &&
        req.request != "DELETE") {

        /* Non-RFC2616 or CONNECT which is weird. */
        return (pipe);
    }

    /* Only consider caching GET/HEAD */
    if (req.request != "GET" && req.request != "HEAD") {
        return (pass);
    }

    {% block vcl_recv_inner %}
    if (req.http.Authorization || req.http.Cookie) {
        return (pass);
    } else {
        return (lookup);
    }
    {% endblock %}
}
{% endblock %}

{% block vcl_fetch %}
{# Use default vcl_fetch #}
{% endblock %}
