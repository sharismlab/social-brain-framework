dbs =  require '../config/db'
less = require "less"
helpers = require "./locals"
httpProxy = require('http-proxy')

module.exports = (app, express, mongoose) ->

  config = this

  # User model
  # UserSchema = require('./models/User') mongoose
  # mongoose.model('User', UserSchema)
  # User = mongoose.model('User');
  
  # u = User.findOne( { "twit.name" : "clemsos" } , (err, data) -> 
  #   console.log data
  # )

  # every auth + mongoose
  everyauth = require('everyauth')

  mongooseAuth = require('mongoose-auth')
  require("./auth") app, mongoose, everyauth, mongooseAuth

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

    app.use mongooseAuth.middleware(app)

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