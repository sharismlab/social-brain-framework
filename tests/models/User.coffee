
UserSchema = require("../src/models/User").UserSchema
User = db.model('User', UserSchema)

twitterUser = require('./support/twitterUser')

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
