#add helpers for http testing 
request = require "supertest"

# Twitter data to fake auth
twitter = require '../support/twitter'
twitterTimeline = require '../../src/lib/twitterTimeline'
twitterAPI = require '../../src/lib/twitterAPI'

module.exports = (db) ->

    # import model
    SeuronSchema = require("../../src/models/Seuron").SeuronSchema

    # Hook up model on active Mongoose connection
    Seuron = db.model('Seuron', SeuronSchema)


    describe "seurons", (done) ->

        s1 = s2 = user = null

        # beforeEach (done) ->
            # add some test data
            # user = User.createWithTwitter( twitterUser, 'accessTok', 'accessTokSecret')
            # done()

        describe "Seuron Timeline Analysis", (done) ->
            # twitterAPI.loginToTwitter(twitter.accessToken,twitter.accessTokenSecret)
            done




###
# this is a test to implement functions without annoying oauth
    app.get '/fake/you', (req, res) ->

        # import libs 
        queue = require '../lib/redis_queue'
        
        


        twitterAPI.loginToTwitter(accessToken,accessTokenSecret)
        # twitlib.verifyCredentials()

        Seuron.findOne { "sns.twitter.id" : String(user_id) } , (err, seuron) ->
            
            
            if (seuron) # check first id the seuron already exists

                # get/update data from twitter for processing data  
                twitterAPI.getFollowers seuron, () ->
                    console.log 'ok followers! '
                
                twitterAPI.getFriends seuron, () ->
                    console.log 'ok followers! '

                twitterAPI.getTimeline (timeline)  ->
                    console.log "timeline loaded !"
                    twitterTimeline.analyzeTimeline timeline
                    # console.log "timeline completed!"

                twitterAPI.getMentions (mentions)  ->
                    console.log "mentions loaded !"
                    twitterTimeline.analyzeTimeline mentions
            
            else 
                #if seuron not found redirect to login 
                console.log "user not found!"
        
        twitterTimeline.timelineEvents.on 'lookup', (data) ->
            console.log "let's look up " + data.users.length + " users from twitter !"
            console.log data

            twitterAPI.lookupUsers data.users, (profiles)  ->
                for profile in profiles
                    Seuron.findOne {"sns.twitter.id": profile .id}, (err, seuron) ->
                        console.log err if err
                        populateWithTwitter profile , () ->
                            console.log "Seuron has now a name : " +seuron.sns.twitter.profile.name


        #render the template...
        res.render '../views/seurons/you.jade'



