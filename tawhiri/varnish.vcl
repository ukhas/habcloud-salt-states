{% extends "http/varnish/default.vcl" %}

{% block vcl_recv_inner %}
    if (req.url ~ "^/datasets/") {
        # Don't try and cache datasets. They're static files anyway, and we
        # need to use "pipe" mode, or if someone downloads a dataset varnish
        # will try and hold an 18gb file in RAM. Not good.
        return (pipe);
    }

    {{ super() }}
{% endblock %}
