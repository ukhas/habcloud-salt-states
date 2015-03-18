{% from "http/macros.jinja" import http %}

{{
  http(
    sites = {
        "predictor-hackathon": {
            "hostname": "predictor-hackathon.vm.habhub.org",
            "aliases": ["predict.cusf.co.uk"],
            "nginx_conf": "salt://http/test/hackathon-nginx-site.conf",
        }
    },
    http_10_host="hackathon"
  )
}}
