dbs =  require '../config/db'
less = require "less"
helpers = require "./locals"

module.exports = (app, express, mongoose) ->

  config = this
  mongoose = require('mongoose')

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

  app.configure "production", ->
    app.use express.errorHandler()
    mongoose.connect "mongodb://flame.mongohq.com:27087/nodemvr"

  
  config