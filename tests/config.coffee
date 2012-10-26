app = require("../src/app")
assert = require("assert")

#add helpers for http testing 
request = require("supertest")

#enable BDD syntax
chai = require 'chai'  
chai.should()

###check files
describe "Config files", ->
	describe 'apikeys.json', ->
		apikeys = require '../config/apikeys'
		it "should exists", (done) ->
			apikeys.should.exist
###
