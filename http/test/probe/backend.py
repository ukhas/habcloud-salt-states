import flask
import werkzeug.contrib.fixers
from flask import Flask, jsonify, request, url_for

app = Flask(__name__)
app_proxyfixed = werkzeug.contrib.fixers.ProxyFix(app)

@app.route("/probe/<nonce>")
def probe(nonce):
    return jsonify(
        nonce=nonce,
        req=request.remote_addr,
        url_for_external=url_for("probe", nonce=nonce, _external=True),
    )

if __name__ == "__main__":
    app.run(debug=True)
