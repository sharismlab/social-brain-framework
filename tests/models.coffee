app = require("../src/app")
assert = require("assert")

#add helpers for http testing 
request = require("supertest")

#enable BDD syntax
chai = require 'chai'  
chai.should()

#MODELS
mongoose = require 'mongoose'
mongooseAuth = require('mongoose-auth')

#tell Mongoose to use a different DB - created on the fly
db = mongoose.createConnection("mongodb://localhost/sb_test")

# import models 
seuronSchema = require("../src/models/Seuron") mongoose
UserSchema = require("../src/models/User") mongoose

#hook up model on active Mongoose connection
Seuron = db.model('Seuron', seuronSchema)
User = db.model('User', UserSchema)

twitterUser = require('./support/twitterUser')

describe "MongoDB", ->

	it "should have a mongo connection", (done) ->
		db.should.exist
		done()

describe "Users", ->
	user = null
	everyauth = {}
	Boolean everyauth.loggedIn

	describe "with a Twitter Account", ->
		
		beforeEach (done) ->
			user = User.createWithTwitter( twitterUser, 'accessTok', 'accessTokSecret')
			done()
		
		afterEach (done)->
      		db.db.dropDatabase();
      		done()
		
		it 'should be able to logged in with Twitter', (done) ->
			request( app )
				.get("/auth/twitter")
				.expect 200
			done()
			

		it 'should be linked to a Seuron', (done) ->
			user.should.have.property('seuron_id')
			done()


describe "Seurons", ->
	
	s1 = s2 = user =null

	beforeEach (done) ->
		# add some test data
		user = new User({ "twit" : twitterUser })
		s1 = new Seuron( { username:"clemsos", twitterID: 12345678, user_id : user, created_at: new Date() } )
		s2 = new Seuron( { username:"isaac", twitterID: 89654321, user_id : user, created_at: new Date() } )
		# s1.createWithTwitter()
		# s1.createWithTwitter()
		done()
		#console.log( s1 )

	#afterEach (done) ->
	
	describe "Seuron model", (done) ->
		
		it "should have a username", (done) ->
			user.should.be.an.instanceof(User)
			s1.username.should.equal 'clemsos'
			done()

		it "should have twitter ID", (done) ->
			s1.twitterID.should.equal 12345678
			done()

		it "should be linked to a user", (done) ->
			s1.user_id.should.equal user._id
			done()

		it "should has a property hasTimeline", (done) ->
			s1.hasTimeline().should.be.true

db.close()