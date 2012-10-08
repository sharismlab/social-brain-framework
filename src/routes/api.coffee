# ## API for Social Brain Framework.
    
# Now only JSON is supported

module.exports = (app) ->
    
    # Home page 
    app.get '/api', (req, res) ->
        res.header 'Cache-Control', 'no-cache'
        res.header 'Expires', 'Fri, 31 Dec 1998 12:00:00 GMT'
        res.send 'The api is currently under development, please stay tuned'

    # Search API, yet to be implemented
    app.get '/api/search', (req, res) ->
        res.header 'Cache-Control', 'no-cache'
        res.header 'Expires', 'Fri, 31 Dec 1998 12:00:00 GMT'
        res.send 'search'

    
    # ## MESSAGE API

    # Import Message model
    Message = require('../models/Message').Message

    # GET All messages
    # > /api/messages.json
    # Will get all messages in the db
    app.get '/api/messages.:format', (req, res) ->

        Message.find {}, (err, messages) ->
            switch req.params.format
                # When json, generate suitable data
                when 'json' then res.send messages.map (d) -> return d.toObject();
                # default
                else res.send "you need to specify a format"

    # GET Single message
    # > /api/message/5072c44f3d3ffb911a000de2.json
    # Get Only specific fields from Seurons in DB
    app.get '/api/messages/:id.:format', (req, res) ->

        Message.findById req.params.id, (err, message) ->

            switch req.params.format
                # When json, generate suitable data
                when 'json' then res.send message
                # default
                else res.send "you need to specify a extension format (.json or .xml)"




    # ## Seurons API

    # Import Seuron model
    Seuron = require('../models/Seuron').Seuron

    # GET all seurons
    # > /api/seurons.json
    # Prevent error by redirection
    app.get '/api/seurons', (req, res) ->
        res.redirect '/api/seurons.'

    # Will return all seurons in the db
    app.get '/api/seurons.:format', (req, res) ->

        Seuron.find {}, (err, seurons) ->
            switch req.params.format
                # When json, generate suitable data
                when 'json' then res.send seurons.map (d) -> return d.toObject();
                # default
                else res.send "you need to specify a format"

    # GET Only specific fields from Seurons in DB
    # > /api/seurons/5072c44f3d3ffb911a000de2.json/friends,followers
    app.get '/api/seurons/:id.:format/:fields?', (req, res) ->

        Seuron.findById req.params.id, req.params.fields, (err, seuron) ->

            switch req.params.format
                # When json, generate suitable data
                when 'json' then res.send seuron
                # default
                else res.send "you need to specify a extension format (.json or .xml)"