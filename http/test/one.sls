{% from "http/macros.jinja" import http %}

{{
  http(
    sites = {
        "scratch": {
            "hostname": "scratch.vm.habhub.org",
            "aliases": ["scratch.public.vm.habhub.org"],
            "nginx_conf": "salt://http/test/one-nginx-site.conf",
            "ssl": None
        },
        "test-one": {
            "hostname": "test-one.habhub.org",
            "aliases": [],
            "nginx_conf": "salt://http/test/one-nginx-site.conf",
            "ssl": {"certificate": "test-one.habhub.org"}
        },
        "test-two": {
            "hostname": "test-two.habhub.org",
            "aliases": [],
            "nginx_conf": "salt://http/test/one-nginx-site.conf",
            "ssl": {"certificate": "test-two.habhub.org"}
        }
    },
    ssl = { "default_certificate": "scratch.vm.habhub.org" },
    http_10_host="test-one"
  )
}}
