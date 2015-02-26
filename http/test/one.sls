{% from "http/macros.jinja" import http %}

{{
  http(
    sites = {
        "one": {"hostname": "scratch.vm.habhub.org",
                "aliases": ["scratch.public.vm.habhub.org"],
                "nginx_conf": "salt://http/test/one-nginx-site.conf"}
    },
    http_10_host="one"
  )
}}
