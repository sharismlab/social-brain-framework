require './app'

module.exports = (db) ->
    
    mongooseAuth = require 'mongoose-auth'
    User = require("../src/models/User").UserSchema

    # Hook up model on active Mongoose connection
    User = db.model('User', UserSchema)

    #fake data
    twitterUser = require('./support/twitterUser')

    # Routes
    describe "Test home", ->
      it "GET / should return 200", (done) ->
        request(app).get("/").expect 200, done