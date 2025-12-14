# app.py
from flask import render_template
from config import connex_app
from trails import read_all
import json

app = connex_app

app.add_api("swagger.yml")

@app.route("/")
def home():
    trails_json = read_all()[0].get_json()
    return render_template("home.html", trails=trails_json)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)
