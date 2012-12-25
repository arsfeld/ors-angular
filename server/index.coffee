"use strict"

express = require("express")
user = require("./user/api")
session = require("./session/api")
fs = require("fs")
http = require("http")
path = require("path")
config = require("./config")
mongoose = require("mongoose")
SessionMongoose = require("session-mongoose")
passport = require("passport")
auth = require("./auth/routes")

# Strategies
passwordRoutes = require("./auth/password/routes")
passwordApi = require("./auth/password/api")

#var FacebookStrategy = require('passport-facebook').Strategy;
API_BASE_URL = "/-/api/v1"
AUTH_URL = "/-/auth"
express.cookieParser "secret"
app = exports.app = express()
app.configure ->
  app.set "port", process.env.PORT or 3000
  app.set "views", __dirname + "/../_public"
  app.set "view engine", "ejs"
  app.set "dbUrl", config.db[app.settings.env]
  app.use express.favicon()
  app.use express.logger("dev")
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser("your secret here")
  app.use passport.initialize()
  app.use passport.session()
  app.use app.router
  app.use express.compress()
  app.use express.static(path.join(__dirname, "../_public"))
  
  # Render *.html files using ejs
  app.engine "html", require("ejs").__express

app.configure "production", ->
  app.use express.session(store: new SessionMongoose(url: app.get("dbUrl")))
  mongoose.connect app.get("dbUrl")

app.configure "development", ->
  mongoose.connect app.get("dbUrl")
  app.use express.errorHandler()
  console.log "Starting Brunch..."
  spawn = require("child_process").spawn
  brunch = spawn("node_modules/brunch/bin/brunch", ["watch"])
  brunch.on "exit", (code) ->
    console.log "Brunch process exited with code " + code

  brunch.stdout.on "data", (data) ->
    console.log "brunch: " + data

  brunch.stderr.on "data", (data) ->
    console.log "brunch error: " + data

app.configure "test", ->
  opts = server:
    auto_reconnect: false

  mongoose.connect app.get("dbUrl"), opts


# Routes //
app.get "/", (req, res) ->
  res.render "index.html"

# auth
app.get AUTH_URL + "/logout", auth.logout
app.post AUTH_URL + "/password", passwordRoutes.start

#app.get(API_BASE_URL + '/auth/facebook/callback', facebook.callback);
#app.get(API_BASE_URL + '/auth/google', facebook.start);
#app.get(API_BASE_URL + '/auth/google/callback', facebook.callback);

# API
app.get API_BASE_URL + "/auth/password", passwordApi.list
app.post API_BASE_URL + "/auth/password", passwordApi.create
app.get API_BASE_URL + "/users", user.list
app.post API_BASE_URL + "/users", user.create
app.get API_BASE_URL + "/users/me", user.current
app.get API_BASE_URL + "/users/:userId", user.read
app.put API_BASE_URL + "/users/:userId", user.update
app.delete API_BASE_URL + '/users/:userId', user.delete

# Catch all route -- If a request makes it this far, it will be passed to angular.
# This allows for html5mode to be set to true. E.g.
# 1. Request '/signup'
# 2. Not found on server.
# 3. Redirected to '/#/signup'
# 4. Caught by the '/' handler passed to Angular
# 5. Angular will check for '#/signup' against it's routes.
# 6. If found
#    a. Browser supports history api -- change the url to '/signup'.
#    b. Browser does not support history api -- keep the url '/#/signup'
app.use (req, res) ->
  res.redirect "/#" + req.path

http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")

