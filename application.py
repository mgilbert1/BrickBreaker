import os
import re
from flask import Flask, jsonify, render_template, request

from cs50 import SQL
from helpers import lookup

# Helpful sites I used:
# https://developers.google.com/maps/documentation/javascript/infowindows#open
# https://developers.google.com/maps/documentation/javascript/markers
# https://developers.google.com/maps/documentation/javascript/tutorial
# http://learn.jquery.com/ajax/jquery-ajax-methods/
# http://learn.jquery.com/using-jquery-core/selecting-elements/
# http://learn.jquery.com/using-jquery-core/document-ready/
# https://stackoverflow.com/questions/8113782/split-string-on-whitespace-in-python
# https://wiki.python.org/moin/ForLoop
# https://www.hmdb.org/marker.asp?marker=4867
# https://stackoverflow.com/questions/5603623/how-can-i-show-label-title-for-marker-permanently-in-google-maps-v3
# https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/pop
# https://www.tutorialspoint.com/python/string_isalpha.htm
# https://www.w3schools.com/sql/sql_like.asp
# https://www.tutorialspoint.com/python/string_isdigit.htm
# http://effbot.org/zone/python-list.htm
# http://www.sqlitetutorial.net/sqlite-index/

# Configure application
app = Flask(__name__)

# Configure CS50 Library to use SQLite database
db = SQL("sqlite:///mashup.db")


# Ensure responses aren't cached
@app.after_request
def after_request(response):
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    response.headers["Expires"] = 0
    response.headers["Pragma"] = "no-cache"
    return response


@app.route("/")
def index():
    """Render map"""
    if not os.environ.get("API_KEY"):
        raise RuntimeError("API_KEY not set")
    return render_template("index.html", key=os.environ.get("API_KEY"))


@app.route("/articles")
def articles():
    """Look up articles for geo"""
    if not request.args.get("geo"):
        raise RuntimeError("missing geo")

    # Look up and return a list of articles
    list = lookup(request.args.get("geo"))
    return jsonify(list[:5])


@app.route("/search")
def search():
    """Search for places that match query"""
    if not request.args.get("q"):
        raise RuntimeError("missing q")
    q = request.args.get("q")
    q2 = ""

    # Filter out any special characters and split the given string
    for c in q:
        if c.isalpha() or c.isdigit():
            q2 += c
        else:
            q2 += " "
    qs = q2.split()

    # Create a list of rows that the user might be searching for
    rows = []
    if len(qs) < 4:
        for i in range(len(qs)):
            # Rows that might match in two columns are added first
            if len(qs) == 2:
                rows += db.execute("SELECT * FROM places WHERE postal_code LIKE :q1 AND admin_name1 LIKE :q2", q1=qs[i] + "%",
                                   q2=qs[(i + 1) % len(qs)] + "%")
                rows += db.execute("SELECT * FROM places WHERE postal_code LIKE :q1 AND place_name LIKE :q2", q1=qs[i] + "%",
                                   q2=qs[(i + 1) % len(qs)] + "%")
                rows += db.execute("SELECT * FROM places WHERE admin_name1 LIKE :q1 AND place_name LIKE :q2", q1=qs[i] + "%",
                                   q2=qs[(i + 1) % len(qs)] + "%")
            # Then rows that might match in just one
            elif len(qs) == 1:
                rows += db.execute("SELECT * FROM places WHERE postal_code LIKE :q1 OR place_name LIKE :q2 OR admin_name1 LIKE :q3",
                                   q1=qs[i] + "%", q2=qs[(i + 1) % len(qs)] + "%", q3=qs[(i + 2) % len(qs)] + "%")
            else:
                # Put any rows that could match in all three columns at the top of rows
                temp = rows
                rows = db.execute("SELECT * FROM places WHERE postal_code LIKE :q1 AND place_name LIKE :q2 AND admin_name1 LIKE :q3",
                                   q1=qs[i] + "%", q2=qs[(i + 1) % len(qs)] + "%", q3=qs[(i + 2) % len(qs)] + "%")
                rows += db.execute("SELECT * FROM places WHERE postal_code LIKE :q1 AND place_name LIKE :q2 AND admin_name1 LIKE :q3",
                                   q3=qs[i] + "%", q2=qs[(i + 1) % len(qs)] + "%", q1=qs[(i + 2) % len(qs)] + "%")
                rows += temp
            # We don't consider cases with more than three inputs because locations aren't formatted that way (by people)

    return jsonify(rows[:4])


@app.route("/update")
def update():
    """Find up to 10 places within view"""

    # Ensure parameters are present
    if not request.args.get("sw"):
        raise RuntimeError("missing sw")
    if not request.args.get("ne"):
        raise RuntimeError("missing ne")

    # Ensure parameters are in lat,lng format
    if not re.search("^-?\d+(?:\.\d+)?,-?\d+(?:\.\d+)?$", request.args.get("sw")):
        raise RuntimeError("invalid sw")
    if not re.search("^-?\d+(?:\.\d+)?,-?\d+(?:\.\d+)?$", request.args.get("ne")):
        raise RuntimeError("invalid ne")

    # Explode southwest corner into two variables
    sw_lat, sw_lng = map(float, request.args.get("sw").split(","))

    # Explode northeast corner into two variables
    ne_lat, ne_lng = map(float, request.args.get("ne").split(","))

    # Find 10 cities within view, pseudorandomly chosen if more within view
    if sw_lng <= ne_lng:

        # Doesn't cross the antimeridian
        rows = db.execute("""SELECT * FROM places
                          WHERE :sw_lat <= latitude AND latitude <= :ne_lat AND (:sw_lng <= longitude AND longitude <= :ne_lng)
                          GROUP BY country_code, place_name, admin_code1
                          ORDER BY RANDOM()
                          LIMIT 10""",
                          sw_lat=sw_lat, ne_lat=ne_lat, sw_lng=sw_lng, ne_lng=ne_lng)

    else:

        # Crosses the antimeridian
        rows = db.execute("""SELECT * FROM places
                          WHERE :sw_lat <= latitude AND latitude <= :ne_lat AND (:sw_lng <= longitude OR longitude <= :ne_lng)
                          GROUP BY country_code, place_name, admin_code1
                          ORDER BY RANDOM()
                          LIMIT 10""",
                          sw_lat=sw_lat, ne_lat=ne_lat, sw_lng=sw_lng, ne_lng=ne_lng)

    # Output places as JSON
    return jsonify(rows)
