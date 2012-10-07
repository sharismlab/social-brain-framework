# Here is all logic and RESTful routes for a Seuron

# Create a ntwitter element to access twitter api
ntwitter = require 'ntwitter'
apikeys = require '../../config/apikeys'


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

            # Load existing seuron related to this account
            Seuron.findOne( { "sns.twitter.profile.id" : String(req.session.auth.twitter.user.id) } 
                , (err, seuron) -> 
                    console.log err if err
                    console.log("seuron loaded")
                    console.log seuron
                    getSeuronData(seuron) # Callback to get data 
            )

            getSeuronData = ( seuron ) ->

                io.sockets.on 'connection', (socket) ->

                    if( seuron.sns.twitter.hasFriends.check == false ) 
                            socket.emit "loading", { text : "Loading Twitter Friends"}
                            seuron.getFriendsFromTwitter( ntwit, ( err, data ) ->
                                if(!err)
                                    socket.emit "done", { text : "Twitter Friends loaded !" }
                                else
                                    socket.emit "done", { text : "Error while loading Twitter Friends"+err }
                                # socket.emit "friends", { data : data }
                            )
                    else 
                        # socket.emit "friends", { data : seuron.sns.twitter.friends }
                        socket.emit "done", { text : "Twitter Friends loaded !" }


                    if( seuron.sns.twitter.hasFollowers.check == false )
                        socket.emit "loading", { text : "Loading Twitter Followers"}
                        seuron.getFollowersFromTwitter( ntwit , (err, data) ->
                            if !err
                                socket.emit "done", { text : "Twitter Followers loaded !" }
                            else
                                socket.emit "done", { text : "Error while loading Twitter Followers"+err }
                            # socket.emit "followers", { data : data }
                        )
                    else 
                        # socket.emit "followers", { data : seuron.sns.twitter.followers }
                        socket.emit "done", { text : "Twitter Followers loaded !" }

                    if( seuron.sns.twitter.hasMentions.check == false ) 
                        socket.emit "loading", { text : "Loading Twitter Mentions Timeline"}
                        seuron.getMentionsFromTwitter( ntwit, ( err, data ) ->
                            if(!err)
                                socket.emit "done", { text : "Twitter Mentions loaded !" }
                            else
                                socket.emit "done", { text : "Error while loading Twitter Mentions !"+err }
                            # socket.emit "mentions", { data : data }
                        )
                    else 
                        # socket.emit "mentions", { data : seuron.sns.twitter.mentions }
                        socket.emit "done", { text : "Twitter Mentions loaded !" }

                    socket.on "mentions_ready", (err) ->
                        console.log "timeline Loading"
                        if( seuron.sns.twitter.hasTimeline.check == false ) 
                            socket.emit "loading", { text : "Loading Twitter Timeline"}

                            seuron.getTimelineFromTwitter( ntwit, ( err, data ) ->
                                if(!err)
                                    socket.emit "done", { text : "Twitter Timeline loaded !" }
                                else
                                    socket.emit "done", { text : "Error while loading Twitter Timeline !" }
                                # socket.emit "timeline", { data : data }
                            )
                        # else 
                            # socket.emit "timeline", { data : seuron.sns.twitter.timeline }


        #render the template...
        res.render '../views/seurons/you.jade'

