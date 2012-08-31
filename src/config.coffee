apikeys =  require '../config/apikeys'
less = require("less")

module.exports = (app, express, mongoose) ->

  config = this
  app.requireAuth = true

  #configure everyauth

  #console.log apikeys.twitter.consumerKey
  #console.log apikeys.twitter.consumerSecret

  Promise = app.everyauth.Promise

  app.everyauth.twitter.consumerKey("apikeys.twitter.consumerKey").consumerSecret("apikeys.twitter.consumerSecret").findOrCreateUser( (session, token, tokenSecret, user) ->
       # promise = @.Promise().fulfill user
       console.log session
       console.log token
       console.log tokenSecret
       console.log user
  ).redirectPath "ok/"

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
    app.use app.everyauth.middleware(app)
    # app.use app.everyauth.middleware()
    app.use express.methodOverride()
    app.use express.static(process.cwd() + '/public')
    app.use app.router
    app.everyauth.helpExpress(app)


  #env specific config
  app.configure "development", ->
    app.use express.errorHandler(
      dumpExceptions: true
      showStack: true
    )
    app.everyauth.debug = true;
    app.mongoose.connect "mongodb://localhost/socialbrain"

  app.configure "production", ->
    app.use express.errorHandler()
    app.mongoose.connect "mongodb://flame.mongohq.com:27087/nodemvr"

  config
