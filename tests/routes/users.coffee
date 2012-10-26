#add helpers for http testing 
request = require "supertest"
mongooseAuth = require 'mongoose-auth'

module.exports = (db, app) ->
    
    UserSchema= require("../../src/models/User").UserSchema

    # Hook up model on active Mongoose connection
    User = db.model('User', UserSchema) app

    #fake data
    twitterUser = require('../support/twitterUser')

    # Users
    describe "User coming for the 1st time", (done) ->

        it "should be able to register with Twitter and Weibo", (done) ->
            done()

        it "should have access to a registration page", (done) ->
            done()

        it "should be able to add name info before", (done) ->
            done()

        it "should see all accounts similar to him", (done) ->
            done()

        it "should not be able to access admin dashboard", (done) ->
            request(app).get("/").expect 300, done
            done()
            

    describe "Logged in User", (done) ->

        beforeEach (done) ->
            # Log in here !
            done()

        it "should be able to add several sns accounts", (done) ->
            done()

        it "should have access to admin dashboard", (done) ->
            done()

        it "should have access to admin dashboard", (done) ->
            done()