require './app'

# Check files
describe "Config files", ->
    describe 'apikeys.json', ->
        apikeys = require '../config/apikeys'
        it "should exists", (done) ->
            apikeys.should.exist

# DBs
describe "Storages", ->
	describe "mongoose", ->
        it "should have a mongo connection", (done) ->
            db.should.exist
            done()