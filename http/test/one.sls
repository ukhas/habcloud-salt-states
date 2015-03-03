{% from "http/macros.jinja" import http %}

{{
  http(
    sites = {
        "scratch": {
            "hostname": "scratch.vm.habhub.org",
            "aliases": ["scratch.public.vm.habhub.org"],
            "nginx_conf": "salt://http/test/one-nginx-site.conf"
        },
        "test-one": {
            "hostname": "test-one.habhub.org",
            "aliases": [],
            "nginx_conf": "salt://http/test/one-nginx-site.conf"
        },
        "test-two": {
            "hostname": "test-two.habhub.org",
            "aliases": [],
            "nginx_conf": "salt://http/test/one-nginx-site.conf"
        }
    },
    varnish = { "http": true, "vcl": none, "memory": "128m" },
    http_10_host="test-one"
  )
}}
