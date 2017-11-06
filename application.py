from cs50 import SQL
from flask import Flask, flash, redirect, render_template, request, session
from flask_session import Session
from tempfile import mkdtemp
from werkzeug.exceptions import default_exceptions
from werkzeug.security import check_password_hash, generate_password_hash

from helpers import apology, login_required, lookup, usd

# Helpful websites I used:
# https://stackoverflow.com/questions/2955459/what-is-an-index-in-sql
# https://stackoverflow.com/questions/379906/parse-string-to-float-or-int
# https://stackoverflow.com/questions/25034123/flask-value-error-view-function-did-not-return-a-response
# http://pocoo-libs.narkive.com/pwsrF5Yy/template-syntax-error-expected-token-got
# https://www.w3schools.com/bootstrap/default.asp
# https://stackoverflow.com/questions/18672452/left-align-and-right-align-within-div-in-bootstrap
# https://stackoverflow.com/questions/3727045/set-variable-in-jinja
# https://stackoverflow.com/questions/9486393/jinja2-change-the-value-of-a-variable-inside-a-loop
# https://support.sendwithus.com/jinja/formatting_numbers/
# http://www.dofactory.com/sql/where-and-or-not
# http://jinja.pocoo.org/docs/2.9/templates/
# https://www.tutorialspoint.com/python/string_isdigit.htm

# Configure application
app = Flask(__name__)

# Ensure responses aren't cached
@app.after_request
def after_request(response):
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    response.headers["Expires"] = 0
    response.headers["Pragma"] = "no-cache"
    return response


# Custom filter
app.jinja_env.filters["usd"] = usd

# Configure session to use filesystem (instead of signed cookies)
app.config["SESSION_FILE_DIR"] = mkdtemp()
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)

# Configure CS50 Library to use SQLite database
db = SQL("sqlite:///finance.db")


@app.route("/")
@login_required
def index():
    """Show portfolio of stocks"""

    # Query database for cash
    cash = db.execute("SELECT cash FROM users WHERE id = :id", id=session["user_id"])

    # Query database for the user's shares
    shares = db.execute("SELECT * FROM portfolio WHERE id =:id", id=session["user_id"])

    # Calculate the total value as well as individual costs for each stock
    total = cash[0]["cash"]
    for share in shares:
        stock_quote = lookup(share["symbol"])
        total += stock_quote["price"] * share["shares"]
        share["cost"] = stock_quote["price"]

    # Render the table
    return render_template("index.html", cash=usd(cash[0]["cash"]), stocks=shares, total=usd(total))


@app.route("/buy", methods=["GET", "POST"])
@login_required
def buy():
    """Buy shares of stock"""

    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":

        # Ensure symbol was submitted
        if not request.form.get("symbol"):
            return apology("must provide symbol", 400)

        # Ensure shares was submitted
        elif not request.form.get("shares"):
            return apology("must provide number of shares", 400)

        # Ensure shares is a valid number
        elif not (request.form.get("shares").isdigit() and int(request.form.get("shares")) > 0):
            return apology("must provide number of shares", 400)

        # Get a quote for the symbol
        stock_quote = lookup(request.form.get("symbol"))

        # Ensure quote is valid
        if not stock_quote:
            return apology("quote is not valid", 400)

        # Query database for cash
        cash = db.execute("SELECT cash FROM users WHERE id = :id", id=session["user_id"])

        # Calculate the cost
        cost = int(request.form.get("shares")) * stock_quote["price"]

        # Update the user's purchased shares and the user's remaining cash if they are able to make the purchase, else return an apology
        if cost <= float(cash[0]["cash"]):

            # Update user's cash
            new_cash = cash[0]["cash"] - cost
            db.execute("UPDATE users SET cash = :new_cash WHERE id = ':id'",
                       new_cash=new_cash, id=session["user_id"])

            # Check if the user has bought this stock before
            stocks = db.execute("SELECT shares FROM portfolio WHERE id = ':id' AND symbol = :symbol", id=session["user_id"],
                                symbol=request.form.get("symbol"))

            # If not, insert a new row into the portfolio
            if len(stocks) != 1:
                db.execute("INSERT INTO portfolio (id, symbol, shares) VALUES(:id, :symbol, :shares)", id=session["user_id"],
                           symbol=request.form.get("symbol"), shares=int(request.form.get("shares")))

            # If yes, update the existing row in the portfolio
            else:
                db.execute("UPDATE portfolio SET shares = ':shares' WHERE id = ':id' AND symbol = :symbol",
                           shares=int(request.form.get("shares")) + stocks[0]["shares"], id=session['user_id'],
                           symbol=request.form.get("symbol"))

            # Add a new row to trades for this trade
            db.execute("INSERT INTO trades (id, symbol, shares, cost) VALUES(:id, :symbol, :shares, :cost)",
                       id=session['user_id'], symbol=request.form.get("symbol"), shares=int(request.form.get("shares")),
                       cost=cost)
        else:
            return apology("You do not have enough cash!", 400)

        # Redirect user to home page
        return redirect("/")

    # User reached route via GET (as by clicking a link or via redirect)
    else:
        return render_template("buy.html")


@app.route("/history")
@login_required
def history():
    """Show history of transactions"""

    # Query database for all trades made
    stocks = db.execute("SELECT * FROM trades WHERE id=':id'", id=session["user_id"])

    # Display table of trades
    return render_template("history.html", stocks=stocks)


@app.route("/login", methods=["GET", "POST"])
def login():
    """Log user in"""

    # Forget any user_id
    session.clear()

    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":

        # Ensure username was submitted
        if not request.form.get("username"):
            return apology("must provide username", 403)

        # Ensure password was submitted
        elif not request.form.get("password"):
            return apology("must provide password", 403)

        # Query database for username
        rows = db.execute("SELECT * FROM users WHERE username = :username",
                          username=request.form.get("username"))

        # Ensure username exists and password is correct
        if len(rows) != 1 or not check_password_hash(rows[0]["hash"], request.form.get("password")):
            return apology("invalid username and/or password", 403)

        # Remember which user has logged in
        session["user_id"] = rows[0]["id"]

        # Redirect user to home page
        return redirect("/")

    # User reached route via GET (as by clicking a link or via redirect)
    else:
        return render_template("login.html")


@app.route("/logout")
def logout():
    """Log user out"""

    # Forget any user_id
    session.clear()

    # Redirect user to login form
    return redirect("/")


@app.route("/quote", methods=["GET", "POST"])
@login_required
def quote():
    """Get stock quote."""

    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":

        # Ensure symbol was submitted
        if not request.form.get("symbol"):
            return apology("must provide a symbol", 400)

        # Get a quote for the symbol
        stock_quote = lookup(request.form.get("symbol"))

        # Ensure quote is valid
        if not stock_quote:
            return apology("quote is not valid", 400)

        # Display the quote
        return render_template("quoted.html", symbol=request.form.get("symbol"), cost=usd(stock_quote["price"]))

    # User reached route via GET (as by clicking a link or via redirect)
    else:
        return render_template("quote.html")


@app.route("/register", methods=["GET", "POST"])
def register():
    """Register user"""

    # Forget any user_id
    session.clear()

    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":

        # Ensure username was submitted
        if not request.form.get("username"):
            return apology("must provide username", 400)

        # Ensure password was submitted
        elif not request.form.get("password"):
            return apology("must provide password", 400)

        # Ensure password confirmation was submitted
        elif not request.form.get("confirmation"):
            return apology("must provide password confirmation", 400)

        # Ensure the two passwords match
        elif not request.form.get("password") == request.form.get("confirmation"):
            return apology("password confirmation must match password", 400)

        # Add username and hashed password to user database
        hash = generate_password_hash(request.form.get("password"))
        result = db.execute("INSERT INTO users (username, hash) VALUES(:username, :hash)",
                            username=request.form.get("username"), hash=hash)

        # Check that the username is not already taken
        if not result:
            return apology("username already taken", 400)

        # Query database for username
        rows = db.execute("SELECT * FROM users WHERE username = :username",
                          username=request.form.get("username"))

        # Log user in
        session["user_id"] = rows[0]["id"]

        # Redirect user to home page
        return redirect("/")

    # User reached route via GET (as by clicking a link or via redirect)
    else:
        return render_template("register.html")


@app.route("/sell", methods=["GET", "POST"])
@login_required
def sell():
    """Sell shares of stock"""

    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":

        # Ensure symbol was submitted
        if not request.form.get("symbol"):
            return apology("must provide symbol", 400)

        # Ensure shares was submitted
        elif not request.form.get("shares"):
            return apology("must provide number of shares", 400)

        # Ensure the user has available stocks to sell
        stock = db.execute("SELECT * FROM portfolio WHERE id=':id' AND symbol= :symbol",
                           id=session["user_id"], symbol=request.form.get("symbol"))
        if int(stock[0]["shares"]) < int(request.form.get("shares")):
            return apology("you don't have enough shares", 400)

        # Get a quote for the symbol
        quote = lookup(request.form.get("symbol"))

        # Query database for cash
        cash = db.execute("SELECT cash FROM users WHERE id = :id", id=session["user_id"])

        # Calculate the cash gain
        gain = int(request.form.get("shares")) * quote["price"]

        # Update user's cash
        new_cash = cash[0]["cash"] + gain
        db.execute("UPDATE users SET cash = :new_cash WHERE id = ':id'",
                   new_cash=new_cash, id=session["user_id"])

        # Delete the row from portfolio if there are 0 stocks left
        if stock[0]["shares"] == request.form.get("shares"):
            db.execute("DELETE FROM portfolio WHERE id=':id' AND symbol=':symbol'",
                       id=session["user_id"], symbol=request.form.get("symbol"))

        # Otherwise update the row
        else:
            db.execute("UPDATE portfolio SET shares=:shares WHERE id=':id' AND symbol=:symbol",
                       shares=stock[0]["shares"] - int(request.form.get("shares")), id=session["user_id"],
                       symbol=request.form.get("symbol"))

        # Add a new row to trades for this trade
        shares = int(request.form.get("shares")) * -1
        db.execute("INSERT INTO trades (id, symbol, shares, cost) VALUES(:id, :symbol, :shares, :cost)", id=session['user_id'],
                   symbol=request.form.get("symbol"), shares=shares, cost=gain)

        # Redirect user to home page
        return redirect("/")

    # User reached route via GET (as by clicking a link or via redirect)
    else:
        stocks = db.execute("SELECT * FROM portfolio WHERE id=':id'", id=session["user_id"])
        return render_template("sell.html", stocks=stocks)


@app.route("/changepw", methods=["GET", "POST"])
@login_required
def changepw():
    """Change the user's password"""

    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":

        # Ensure old password was submitted
        if not request.form.get("old_password"):
            return apology("must provide old password", 400)

        # Query database for this user
        rows = db.execute("SELECT * FROM users WHERE id=':id'",
                          id=session["user_id"])

        # Ensure old password is correct
        if not check_password_hash(rows[0]["hash"], request.form.get("old_password")):
            return apology("invalid password", 403)

        # Ensure new password was submitted
        elif not request.form.get("new_password"):
            return apology("must provide new password", 400)

        # Ensure password confirmation was submitted
        elif not request.form.get("confirmation"):
            return apology("must provide password confirmation", 400)

        # Ensure the two passwords match
        elif not request.form.get("new_password") == request.form.get("confirmation"):
            return apology("password confirmation must match password", 400)

        # Update hashed password in user database
        hash = generate_password_hash(request.form.get("new_password"))
        result = db.execute("UPDATE users SET hash=:hash",
                            hash=hash)

        # Redirect user to home page
        return redirect("/")

    else:
        return render_template("changepw.html")


def errorhandler(e):
    """Handle error"""
    return apology(e.name, e.code)


# listen for errors
for code in default_exceptions:
    app.errorhandler(code)(errorhandler)
