#!/usr/bin/python3

import sys
import os
import os.path
import time
import json
import itertools
import pprint
import glob
import base64
import subprocess
import tempfile
import http.client

class VarnishRealIPs:
    def __init__(self, nonce):
        self.proc = self.tempfile = None

        m = 'RxURL:^/probe/{}$'.format(nonce)
        self.tempfile = tempfile.NamedTemporaryFile("w+", buffering=1)

        with open(self.tempfile.name, "wb", 0) as f:
            self.proc = subprocess.Popen(["varnishlog", "-c", "-m", m, "-u"],
                                         stdout=f)

        time.sleep(0.1)

    def close(self):
        if self.proc:
            self.proc.terminate()
            self.proc.wait()
            self.proc = None

        if self.tempfile:
            self.tempfile.close()
            self.tempfile = None

    def _collect(self):
        self.tempfile.seek(0, os.SEEK_CUR)

        real_ips = {}

        for line in self.tempfile:
            req_id, tag, with_client, *rest = line.split()
            req_id = int(req_id)
            if tag == "ReqEnd":
                try:
                    yield real_ips[req_id]
                    del real_ips[req_id]
                except KeyError:
                    raise ValueError("X-Real-IP line missing for req", req_id)
            elif tag == "VCL_Log" and rest[0] == "X-Real-IP:":
                if req_id in real_ips:
                    raise ValueError("X-Real-IP line arrived twice for req", req_id)
                else:
                    _, ip = rest
                    real_ips[req_id] = ip

        if len(real_ips) != 0:
            raise ValueError("Some requests didn't end")

    def collect(self):
        return list(self._collect())

    def __enter__(self):
        return self

    def __exit__(self, a, b, c):
        self.close()

    def __del__(self):
        self.close()

class NginxLogs:
    def __init__(self, nonce):
        self.files = None

        self.url = "/probe/{}".format(nonce)
        self.files = [(self._strip_name(n), self._open_at_end(n))
                      for n in glob.glob("/var/log/nginx/*.access.log")]

    @staticmethod
    def _open_at_end(name):
        f = open(name, "r")
        f.seek(0, os.SEEK_END)
        return f

    @staticmethod
    def _strip_name(filename):
        bn = os.path.basename(filename)
        assert bn.endswith(".access.log")
        return bn[:-len(".access.log")]

    def _collect_one(self, name, file):
        # This convinces python to look for more data if it has previously seen EOF
        file.seek(0, os.SEEK_CUR)

        for line in file:
            ip, _, _, _, _, _, url, *_ = line.split()
            if url == self.url:
                yield name, ip

    def collect(self):
        chain = itertools.chain.from_iterable
        starmap = itertools.starmap
        return list(chain(starmap(self._collect_one, self.files)))

    def close(self):
        if self.files:
            for _, f in self.files:
                f.close()

            self.files = None

    def __enter__(self):
        return self

    def __exit__(self, a, b, c):
        self.close()

    def __del__(self):
        self.close()

def test(connect, http_host, ssl):
    """
    connect: the IP/hostname to initiate a connection to
    http_host: the hostname that should go in the "Host: X" header
    """

    nonce = base64.b16encode(os.urandom(10)).decode("ascii")

    with VarnishRealIPs(nonce) as vrps, NginxLogs(nonce) as ngl:
        if ssl:
            conn = http.client.HTTPSConnection(connect)
        else:
            conn = http.client.HTTPConnection(connect)

        headers = {
            "Host": http_host,
            "X-Forwarded-For": "9.9.9.9",
            "X-Forwarded-Host": "garbage-host",
            "X-Forwarded-Proto": "banana"
        }

        conn.request("GET", "/probe/{}".format(nonce), headers=headers)
        resp = conn.getresponse()
        contents = resp.read()
        conn.close()

        time.sleep(0.1)
        varnish_hits = vrps.collect()
        nginx_hits = ngl.collect()

    habcloud_site_headers = [val for hdr, val in resp.getheaders()
                             if hdr == "X-habcloud-site"]

    via =   [("varnish", ip)     for ip in varnish_hits] \
          + [("nginx", site, ip) for site, ip in nginx_hits]

    if resp.status == 200:
        response = json.loads(contents.decode("ascii"))
    else:
        response = None

    return {
        "status": resp.status,
        "habcloud_site_headers": habcloud_site_headers,
        "via": via,
        "response": response
    }

if __name__ == "__main__":
    if len(sys.argv) == 3:
        _, connect, http_host = sys.argv
        ssl = False
    elif len(sys.argv) == 4 and sys.argv[3] == "ssl":
        _, connect, http_host, _ = sys.argv
        ssl = True
    else:
        print("Usage", sys.argv[0], "connect-to", "http-host", "[ssl]", file=sys.stderr)
        sys.exit(1)

    pprint.pprint(test(connect, http_host, ssl), sys.stdout, width=120)
