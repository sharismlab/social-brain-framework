###
config file for SBF app
###

dbs =  require '../config/db'
less = require "less"
helpers = require "./locals"
httpProxy = require('http-proxy')

# every auth + mongoose
everyauth = require('everyauth')
mongooseAuth = require 'mongoose-auth'

#Let's configure everyauth
everyauth.debug = true

# require './lib/auth'
# require('./models/User').User


# Fix for broken expressHelpers
# https://github.com/bnoguchi/everyauth/issues/303
preEveryAuthMiddlewareHack = ->
  (req, res, next) ->
    sess = req.session
    auth = sess.auth
    ea =
      loggedIn: auth?.loggedIn

    ea[k] = val for own k, val of auth

    if everyauth.enabled.password
      ea.password = ea.password || {}
      ea.password.loginFormFieldName = everyauth.password.loginFormFieldName()
      ea.password.passwordFormFieldName = everyauth.password.passwordFormFieldName()

    res.locals.everyauth = ea

    do next

postEveryAuthMiddlewareHack = ->
  userAlias = everyauth.expressHelperUserAlias || "user"
  (req, res, next) ->
    res.locals.everyauth.user = req.user
    res.locals[userAlias] = req.user
    do next

module.exports = (app, express, mongoose) ->

  config = this

  # required for mongoose-auth to work
  User = require('./models/User').User


  #generic config
  app.configure ->
    app.set "views", __dirname + "/views"
    app.set "view engine", "jade"
    app.use express.cookieParser()

    app.engine 'html', require('ejs').renderFile

    app.use express.favicon()

    app.use express.session( {
    secret: "topsecret",
    maxAge: new Date(Date.now() + 3600000)
    })


    app.use preEveryAuthMiddlewareHack()
    app.use mongooseAuth.middleware(app)
    app.use postEveryAuthMiddlewareHack()

    app.use express.bodyParser()
    app.use express.methodOverride()
    app.use express.static(process.cwd() + '/public')
    # app.use app.router

  #env specific config
  app.configure "development", ->
    app.use express.errorHandler(
      dumpExceptions: true
      showStack: true
    )
    mongoose.connect dbs.dev.database
    # Create proxy server to use port 80
    proxyServer = httpProxy.createServer(3000, '127.0.0.1');
    proxyServer.listen(80);

  app.configure "production", ->
    app.use express.errorHandler()
    mongoose.connect dbs.prod.database
    proxyServer = httpProxy.createServer(3000, '106.187.52.150');
    proxyServer.listen(80);


  # //mongooseAuth.helpExpress(app);
  
  config
