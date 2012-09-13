##    ROUTES
#########################

module.exports = (app, io, mongoose) ->


    require('./routes/users') app

    # if(everyauth.loggedIn) 
    #     console.log "loggedIn"
    # else
    #     console.log "not loggedIn"


    app.get '/', (req, res) -> 
      res.render "index"

    app.get '/about', (req, res) ->
      res.render "about"

    app.get '/seuron', (req, res) ->
        # console.log req.user if (req.user)
        # io.sockets.on 'connection', (socket) ->
        # socket.emit 'bla', {data:"blabla from server"};        
        # s = Seuron.findOne({ 'user_id': user_id })
        if (req.user)

            # create a ntwitter element
            ntwitter = require 'ntwitter'
            apikeys = require '../config/apikeys'

            tok ="136861797-3GmHLyD80c6SsoY6CNz04lWEgUe4fkSQWO9YwLwi"
            tokSec = "FJUTmsmlRCPONjNHd53MVaglGmRtIKt4TyDdWyMuPE"


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

            # console.log(seuron)

            s = Seuron.findOne( { "sns.twitter.profile.id" : req.session.auth.twitter.user.id } 
                , (err, seuron) -> 
                    console.log err if err
                    console.log("seuron loaded")
                    # console.log data
                    getSeuronData( seuron )
            )

            # console.log(seuron)

            getSeuronData = ( seuron ) ->
                
                console.log seuron.sns.twitter.hasTimeline.check
                # console.log seuron.sns.twitter.hasTimeline.check
                console.log seuron.sns.twitter.hasFriends.check
                console.log seuron.sns.hasFollowers.check

                io.sockets.on 'connection', (socket) ->
                    socket.emit 'loggedIn', { data: req.session.auth.twitter.user };              
                    socket.on "bla", (mess)->
                        console.log mess

                    if( seuron.sns.twitter.hasTimeline.check == false ) 
                        socket.emit "loading", { text : "Loading Twitter Timeline"}
                        seuron.getTimelineFromTwitter( ntwit, ( data ) ->
                            socket.emit "done", { text : "Twitter Timeline loaded !" }
                            socket.emit "timeline", { data : data }
                        )
                    else 
                        socket.emit "timeline", { data : seuron.sns.twitter.timeline }

                    if( seuron.sns.twitter.hasTimeline.check == false ) 
                        socket.emit "loading", { text : "Loading Twitter Friends"}
                        seuron.getFriendsFromTwitter( ntwit, ( data ) ->
                            socket.emit "done", { text : "Twitter Friends loaded !" }
                            socket.emit "friends", { data : data }
                        )
                    else 
                        socket.emit "friends", { data : seuron.sns.twitter.friends }

                    if( seuron.sns.twitter.hasTimeline.check == false )
                        socket.emit "loading", { text : "Loading Twitter Followers"}
                        seuron.getFollowersFromTwitter( ntwit , (data) ->
                            socket.emit "done", { text : "Twitter Followers loaded !" }
                            socket.emit "followers", { data : data }
                        )
                    else 
                        socket.emit "followers", { data : seuron.sns.twitter.followers }


                    socket.on "lookup", (data) ->
                        console.log data
                        
                        ntwit.lookupUser( data.ids.ids, (err, users)->
                            console.log err if err
                            console.log users
                            d = unescape( encodeURIComponent( JSON.stringify( users ) ) );
                            socket.emit "users", { profiles : d }
                        )  





        res.render "seuron", { userdata: app.everyauth }

        # res.header 'Cache-Control', 'no-cache'
        # res.header 'Expires', 'Fri, 31 Dec 1998 12:00:00 GMT'
        # res.send timeline
        # res.send '<a href="/auth/twitter">login with twitter</a>'



    app.get '/api', (req, res) ->
        res.header 'Cache-Control', 'no-cache'
        res.header 'Expires', 'Fri, 31 Dec 1998 12:00:00 GMT'
        res.send 'api'

    app.get '/api/search', (req, res) ->
        res.header 'Cache-Control', 'no-cache'
        res.header 'Expires', 'Fri, 31 Dec 1998 12:00:00 GMT'
        res.send 'search'