apikeys =  require '../config/apikeys'
less = require "less"
helpers = require "./locals"

# Fix for broken expressHelpers; https://github.com/bnoguchi/everyauth/issues/303
preEveryAuthMiddlewareHack: ->
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

postEveryAuthMiddlewareHack: ->
  userAlias = everyauth.expressHelperUserAlias || "user"
  (req, res, next) ->
    res.locals.everyauth.user = req.user
    res.locals[userAlias] = req.user
    do next

module.exports = (app, express, mongoose) ->

  config = this

  ## OAUTh
  app.everyauth = require('everyauth')
  Promise = app.everyauth.Promise;

  app.everyauth.debug = true;

  # User model
  app.mongoose = require('mongoose')
  mongoose = app.mongoose

  # models.user = require('./models/user')(app.mongoose).model
  Schema = mongoose.Schema
  ObjectId = mongoose.SchemaTypes.ObjectId

  UserSchema = new Schema({})
  User

  mongooseAuth = require('mongoose-auth');

  #configure everyauth
  UserSchema.plugin mongooseAuth,
    everymodule:
      everyauth:
        User: ->
          User

    twitter:
      everyauth:
        myHostname: "http://local.host:3000"
        consumerKey: apikeys.twitter.consumerKey
        consumerSecret: apikeys.twitter.consumerSecret
        redirectPath: "/"

  mongoose.model('User', UserSchema)
  mongoose.connect('mongodb://localhost/example');

  User = mongoose.model('User');

  
  # mongooseAuth.helpExpress(app);

  #generic config
  app.configure ->
    app.set "views", __dirname + "/views"
    app.set "view engine", "jade"
    app.use express.bodyParser()
    app.use express.cookieParser()

    app.use express.session( {
    secret: "topsecret",
    maxAge: new Date(Date.now() + 3600000)
    })

    app.use express.methodOverride()

    # app.use helpers.preEveryauthMiddlewareHack 
    app.use mongooseAuth.middleware(app)
    # app.use helpers.postEveryauthMiddlewareHack

    app.use express.static(process.cwd() + '/public')
    # app.use app.router

  #env specific config
  app.configure "development", ->
    app.use express.errorHandler(
      dumpExceptions: true
      showStack: true
    )
    app.everyauth.debug = true;
    #app.mongoose.connect "mongodb://localhost/socialbrain"

  app.configure "production", ->
    app.use express.errorHandler()
    app.mongoose.connect "mongodb://flame.mongohq.com:27087/nodemvr"

  config
