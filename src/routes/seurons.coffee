# Here is all logic and RESTful routes for a Seuron

# Create a ntwitter element to access twitter api
ntwitter = require 'ntwitter'
apikeys = require '../../config/apikeys'

# Here goes some sample data for local development
clemsos_friends = require "../../public/viz/seuron_viz/examples/petridish/datasamples/clemsos_friends.json"

clemsos_followers  = require "../../public/viz/seuron_viz/examples/petridish/datasamples/clemsos_followers.json"

clemsos_timeline  = require "../../public/viz/seuron_viz/examples/petridish/datasamples/clemsos_timeline.json"

module.exports = (app, mongoose, io) ->

    # Import Seuron model
    Seuron = require('../models/Seuron').Seuron
    
    # GET 
    app.get '/seurons', (req, res) ->

        Seuron.find {}, (err, seurons) ->
            console.log seurons
            res.render '../views/seurons/index.jade', { seurons: seurons }
        
    # GET one seuron and display it
    app.get '/seurons/:id', (req, res) ->

        # Prevent accesing /seurons/you by redirecting to you
        
        if(req.params.id == 'you')
            res.redirect('/you')
        else 
            Seuron.findById req.params.id, (err, seuron) ->

            # Prevent null or errors
            res.send 'Document not found' if !seuron 
            res.send err if err

            # Render the template...
            res.render '../views/seurons/single.jade', { seuron: seuron }
   
    # YOU, The page where we will display all visualization of the demo
    # This is a persolnalized page where people can browse their own seuron
    app.get '/you', (req,res) ->

        # mongoose.set('debug', true)

        # Check first if our user is logged in with twitter
        # then launch the data check + gathering from twitter
        if (typeof req.session.auth.twitter !='undefined')
    
            # Retrieve the token and secret token to use for twitter API 
            tok = req.session.auth.twitter.accessToken
            tokSec =  req.session.auth.twitter.accessTokenSecret

            # Create a ntwitter element using user credentials
            # So we can retrieve info (friends, followers, etc.) using those credentials
            # use logged in user credentials to process requests
            ntwit = new ntwitter (    
                consumer_key: apikeys.twitter.consumerKey
                consumer_secret: apikeys.twitter.consumerSecret
                access_token_key: tok
                access_token_secret: tokSec
            )

            # Load Seuron controller
            seurons_controller = require('../controllers/seurons_controller') ntwit

            # Load existing seuron related to this account
            Seuron.findOne { "sns.twitter.profile.id" : String(req.session.auth.twitter.user.id) } , (err, seuron) -> 
                    console.log err if err
                    console.log("seuron loaded")
                    console.log seuron
                    
                    # get Friends and Followers from Twitter API
                    # we check before if seurons isn't already populated with Friends or Followers
                    if( seuron.sns.twitter.hasFriends.check == false || seuron.sns.twitter.hasFriends.last_updated < Date.now+30000)
                        seurons_controller.getFriendsFromTwitter seuron, ( err, data ) ->
                            console.log err if err
                            console.log data

                    if( seuron.sns.twitter.hasFollowers.check == false || seuron.sns.twitter.hasFollowers.last_updated < Date.now+30000)
                        seurons_controller.getFollowersFromTwitter seuron, ( err, data ) ->
                            console.log err if err
                            console.log data

                    seurons_controller.getTimelineFromTwitter ( err, timeline ) ->
                        console.log "timeline.length " +timeline.length
                        # Add timeline data into redis
                        queueMessageInRedis message for message in timeline

    
        #render the template...
        res.render '../views/seurons/you.jade'

    # this is a test to implement functions without annoying oauth
    app.get '/fake/you', (req, res) ->

        request = require 'request'

        # import libs 
        queue = require '../lib/redis_queue'
        twitterFunctions = require '../lib/twitterTimeline'
        
        # faking user id
        user_id = 136861797


        Seuron.findOne { "sns.twitter.profile.id" : String(user_id) } , (err, seuron) ->
            
            console.log "------------------------ seuron founded !" 
            console.log seuron 

            
            if( seuron.sns.twitter.hasFollowers.check == false || seuron.sns.twitter.hasFollowers.last_updated < Date.now+30000)
                # seurons_controller.getFollowersFromTwitter
                console.log "get followers !"

                seuron.sns.twitter.followers = clemsos_followers.ids
                seuron.sns.twitter.hasFollowers.check = true
                seuron.sns.twitter.hasFollowers.last_updated = new Date
                seuron.save (d) ->
                    console.log 'followers added to seuron'
                    console.log d
                    
            if( seuron.sns.twitter.hasFriends.check == false || seuron.sns.twitter.hasFriends.last_updated < Date.now+30000)
                # seurons_controller.getFollowersFromTwitter
                console.log "get friends !"

                seuron.sns.twitter.friends = clemsos_friends.ids
                seuron.sns.twitter.hasFriends.check = true
                seuron.sns.twitter.hasFriends.last_updated = new Date
                seuron.save (d) ->
                    console.log 'friends added to seuron'
                    console.log d

            console.log "timeline loaded !"
            twitterFunctions.analyzeTimeline clemsos_timeline





        #render the template...
        res.render '../views/seurons/you.jade'

