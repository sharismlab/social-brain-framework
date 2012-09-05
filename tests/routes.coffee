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

# import models 
seuronSchema = require("../src/models/Seuron") mongoose
UserSchema = require("../src/models/User") mongoose
db = mongoose.createConnection("mongodb://localhost/sb_test")

#hook up model on active Mongoose connection
Seuron = db.model('Seuron', seuronSchema)
User = db.model('Seuron', UserSchema)

twitterUser = require('./support/twitterUser')


# Routes
describe "Test home", ->
  it "GET / should return 200", (done) ->
    request(app).get("/").expect 200, done

describe "users", (done) ->
	it "should create a Seuron object at the first log in", (done) ->
		

describe "seurons", (done) ->

	s1 = s2 = null

	beforeEach (done) ->
		# add some test data
		user = new User({ "twit" : twitterUser })
		s1 = new Seuron( { username:"clemsos", twitterID: 12345678, user : user, created_at: new Date() } )
		s2 = new Seuron( { username:"isaac", twitterID: 89654321, user : user, created_at: new Date() } )
		done()
		#console.log( s1 )

	describe " Seuron routes", (done) ->

		it 'should be able to read the terms of use', ->
			request( app ).get("/termsofuse").expect 200, done
			# termsOfUse().should.be.true

		it 'should agree with terms of use', ->
			s1.agreeTerms().should.exist()

		it 'should fetch timeline from Twitter', ->  
		    s1.complete().should.be.true  
		    s1.status.should.equal 'complete'


	describe "Seuron methods", (done) ->

		it "should be retrieved by Twitter ID", (done) ->
			s1.findByTwitterID( 12345678, (doc) ->
				doc.twitterID.should.equal(12345678)
			)

		it 'should be retrieved using User mongoID', (done) ->
			s1.findByTwitterID( 12345678, (doc) ->
				doc.twitterID.should.equal(12345678)
			)