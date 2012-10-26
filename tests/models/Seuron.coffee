# Here goes some sample data
clemsos_friends = require "../../public/viz/seuron_viz/examples/petridish/datasamples/clemsos_friends.json"

clemsos_followers  = require "../../public/viz/seuron_viz/examples/petridish/datasamples/clemsos_followers.json"

clemsos_timeline  = require "../../public/viz/seuron_viz/examples/petridish/datasamples/clemsos_timeline.json"

clemsos_mentions  = require "../../public/viz/seuron_viz/examples/petridish/datasamples/clemsos_mentions.json"


module.exports = (db) ->

    # import models 
    seuronSchema = require("../src/models/Seuron").SeuronSchema

    #hook up model on active Mongoose connection
    Seuron = db.model('Seuron', seuronSchema)

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