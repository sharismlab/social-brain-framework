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

    # Seurons API

    # Import Seuron model
    Seuron = require('../models/Seuron').Seuron

    # GET all seurons

    # Prevent error by redirection
    app.get '/api/seurons', (req, res) ->
        res.redirect '/api/seurons.'

    # This is juts for test purposes. 
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

