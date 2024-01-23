from flask_cors import CORS
from flask import Flask, request, jsonify, render_template
from datetime import datetime
import requests, json

app = Flask(__name__)
CORS(app, resources={r"*": {"origins": "*"}})


@app.route("/", methods=["GET"])
def write_log():
    now = datetime.now()
    with open("/var/log/poc-gce-logging-router.log", "a") as log:
        log.write(
            f"{now.strftime('[%d/%b/%Y %H:%M:%S]')} poc-gce-logging-router\n"
        )
    return "Populating /var/log/poc-gce-logging-router.log"


app.run(host="0.0.0.0", port=5000)
