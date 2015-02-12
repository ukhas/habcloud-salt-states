{% block backends %}
backend default {
    .host = "{{ backend_host|default("127.0.0.1") }}";
    .port = "{{ backend_port|default(2080) }}";
}
{% endblock %}

{% block vcl_recv %}
sub vcl_recv {
    set req.http.X-Forwarded-For = client.ip;

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

    # Only consider caching GET/HEAD
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
