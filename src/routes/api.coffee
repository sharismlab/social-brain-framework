# API
# All routing about API
# Now only JSON implemented

module.exports = (app) ->
    
    app.get '/api', (req, res) ->
        res.header 'Cache-Control', 'no-cache'
        res.header 'Expires', 'Fri, 31 Dec 1998 12:00:00 GMT'
        res.send 'The api is currently under development, please stay tuned'

    app.get '/api/search', (req, res) ->
        res.header 'Cache-Control', 'no-cache'
        res.header 'Expires', 'Fri, 31 Dec 1998 12:00:00 GMT'
        res.send 'search'

    
    #MESSAGE API 
    # Import Message model
    Message = require('../models/Message').Message

    # Will get all messages in the db
    app.get '/api/messages.:format', (req, res) ->

        Message.find {}, (err, messages) ->
            switch req.params.format
                # When json, generate suitable data
                when 'json' then res.send messages.map (d) -> return d.toObject();
                # default
                else res.send "you need to specify a format"

    # Get Only specific fields from Seurons in DB
    app.get '/api/messages/:id.:format', (req, res) ->

        Message.findById req.params.id, (err, message) ->

            switch req.params.format
                # When json, generate suitable data
                when 'json' then res.send message
                # default
                else res.send "you need to specify a extension format (.json or .xml)"




    # Seurons API

    # Import Seuron model
    Seuron = require('../models/Seuron').Seuron

    # GET all seurons

    # Prevent error by redirection
    app.get '/api/seurons', (req, res) ->
        res.redirect '/api/seurons.'

    # Will get all seurons in the db
    app.get '/api/seurons.:format', (req, res) ->

        Seuron.find {}, (err, seurons) ->
            switch req.params.format
                # When json, generate suitable data
                when 'json' then res.send seurons.map (d) -> return d.toObject();
                # default
                else res.send "you need to specify a format"

    # Get Only specific fields from Seurons in DB
    app.get '/api/seurons/:id.:format/:fields?', (req, res) ->

        Seuron.findById req.params.id, req.params.fields, (err, seuron) ->

            switch req.params.format
                # When json, generate suitable data
                when 'json' then res.send seuron
                # default
                else res.send "you need to specify a extension format (.json or .xml)"


    # Here goes some sample data for local development
    friends = require "../../public/viz/seuron_viz/examples/petridish/datasamples/clemsos_friends.json"

    followers  = require "../../public/viz/seuron_viz/examples/petridish/datasamples/clemsos_followers.json"

    app.get '/api/fake/timeline', (req, res) ->
        data = require "../../public/viz/seuron_viz/examples/petridish/datasamples/clemsos_timeline.json"
        
        res.json data

    app.get '/api/fake/friends', (req, res) ->
        # res.header 'Content-Type': 'application/json'
        console.log friends
        res.jsonp friends

    app.get '/api/fake/followers', (req, res) ->
        
        # res.header 'Content-Type': 'application/json'
        res.jsonp followers

    app.get '/api/fake/mentions', (req, res) ->
        data = require "../../public/viz/seuron_viz/examples/petridish/datasamples/clemsos_mentions.json"
        res.header 'Content-Type': 'application/json'
        res.json data

    app.get '/api/fake/profile', (req, res) ->
        data = require "../../public/viz/seuron_viz/examples/petridish/datasamples/clemsos_profile.json"
        res.header 'Content-Type': 'application/json'
        res.json data
   