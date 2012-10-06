##    ROUTES
#########################

module.exports = (app, io, mongoose) ->



    # some static pages 
    app.get '/', (req, res) -> 
      res.render "index"

    app.get '/about', (req, res) ->
      res.render "about"

    app.get '/join', (req, res) ->
      res.send "join"
    

    # get specific routes
    require('./routes/users') app
    require('./routes/api') app




    app.get '/seuron', (req, res) ->
        
        if (req.user)

            # create a ntwitter element
            ntwitter = require 'ntwitter'
            apikeys = require '../config/apikeys'

            # console.log req.session
            tok = req.session.auth.twitter.accessToken
            tokSec =  req.session.auth.twitter.accessTokenSecret

            #use logged in user credentials to process requests
            ntwit = new ntwitter (    
                consumer_key: apikeys.twitter.consumerKey
                consumer_secret: apikeys.twitter.consumerSecret
                access_token_key: tok
                access_token_secret: tokSec
            )

            #Import seuron model
            SeuronSchema = require('./models/Seuron') mongoose
            mongoose.model('Seuron', SeuronSchema)
            Seuron = mongoose.model('Seuron');

            s = Seuron.findOne( { "sns.twitter.profile.id" : req.session.auth.twitter.user.id } 
                , (err, seuron) -> 
                    console.log err if err
                    console.log("seuron loaded")
                    console.log seuron
                    getSeuronData( seuron ) # callback to get data 
            )

            # console.log(seuron)

            getSeuronData = ( seuron ) ->
                
                console.log "has Timeline : " + seuron.sns.twitter.hasTimeline.check
                console.log "has Mentions : " +seuron.sns.twitter.hasMentions.check
                console.log "has Friends : " +seuron.sns.twitter.hasFriends.check
                console.log "has Followers : " +seuron.sns.twitter.hasFollowers.check

                io.sockets.on 'connection', (socket) ->
                    socket.emit 'loggedIn', { data: req.session.auth.twitter.user };              
                    socket.on "bla", (mess)->
                        console.log mess

                    if( seuron.sns.twitter.hasFriends.check == false ) 
                        socket.emit "loading", { text : "Loading Twitter Friends"}
                        seuron.getFriendsFromTwitter( ntwit, ( data ) ->
                            socket.emit "done", { text : "Twitter Friends loaded !" }
                            socket.emit "friends", { data : data }
                        )
                    else 
                        socket.emit "friends", { data : seuron.sns.twitter.friends }


                    if( seuron.sns.twitter.hasFollowers.check == false )
                        socket.emit "loading", { text : "Loading Twitter Followers"}
                        seuron.getFollowersFromTwitter( ntwit , (data) ->
                            socket.emit "done", { text : "Twitter Followers loaded !" }
                            socket.emit "followers", { data : data }
                        )
                    else 
                        socket.emit "followers", { data : seuron.sns.twitter.followers }

                    if( seuron.sns.twitter.hasMentions.check == false ) 
                        socket.emit "loading", { text : "Loading Twitter Mentions Timeline"}
                        seuron.getMentionsFromTwitter( ntwit, ( data ) ->
                            socket.emit "done", { text : "Twitter Mentions loaded !" }
                            socket.emit "mentions", { data : data }
                        )
                    else 
                        socket.emit "mentions", { data : seuron.sns.twitter.mentions }

                    socket.on "mentions_ready", (err) ->
                        console.log "timeline Loading"
                        # if( seuron.sns.twitter.hasTimeline.check == false ) 
                        socket.emit "loading", { text : "Loading Twitter Timeline"}

                        seuron.getTimelineFromTwitter( ntwit, ( data ) ->
                            socket.emit "done", { text : "Twitter Timeline loaded !" }
                            socket.emit "timeline", { data : data }
                        )
                        # else 
                            # socket.emit "timeline", { data : seuron.sns.twitter.timeline }

                    socket.on "lookup", (data) ->
                        console.log data
                        
                        ntwit.lookupUser( data.ids.ids, (err, users)->
                            console.log err if err
                            console.log users
                            d = unescape( encodeURIComponent( JSON.stringify( users ) ) );
                            socket.emit "users", { profiles : d }
                        )  

        res.render "seuron", { userdata: app.everyauth }