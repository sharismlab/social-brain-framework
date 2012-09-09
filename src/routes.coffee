##    ROUTES
#########################
twidata  = null
module.exports = (app, models) ->


    require('./routes/users') app


    app.get '/', (req, res) -> 
      res.render "index"

    app.get '/about', (req, res) ->
      res.render "about"

    app.get '/seuron', (req, res) ->
         #console.log req.user if (req.user)
        
        if (req.user)
            console.log req.user.
            # create a ntwitter element
            ntwitter = require 'ntwitter'
            apikeys = require '../config/apikeys'
            #twidata = req.user
            # console.log twidata


            #use logged in user credentials do process requests
            ntwit = new ntwitter (
                consumer_key: apikeys.twitter.consumerKey
                consumer_secret: apikeys.twitter.consumerSecret
                access_token_key: twidata.twi.accessToken
                access_token_secret: twidata.twi.accessTokenSecret
            )

            #get logged user timeline
            timeline = null

            ntwit.getUserTimeline {"user_id": userdata.userID, "include_entities" : true }, (err,data) ->
                timeline = data

            res.header 'Cache-Control', 'no-cache'
            res.header 'Expires', 'Fri, 31 Dec 1998 12:00:00 GMT'
            res.send timeline

        res.send '<a href="/auth/twitter">login with twitter</a>'
      # res.render "seuron", { userdata: app.everyauth }


    app.get '/api', (req, res) ->
        res.header 'Cache-Control', 'no-cache'
        res.header 'Expires', 'Fri, 31 Dec 1998 12:00:00 GMT'
        res.send 'api'

    app.get '/api/search', (req, res) ->
        res.header 'Cache-Control', 'no-cache'
        res.header 'Expires', 'Fri, 31 Dec 1998 12:00:00 GMT'
        res.send 'search'

