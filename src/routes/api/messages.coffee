# ## MESSAGE API

module.exports = (app) ->

    # Import Message model
    Message = require('../../models/Message').Message

    # All messages
    # GET
    # Example: http://website/api/messages
    # Will get all messages in the db
    # app.get '/api/messages.:format', (req, res) ->
    #     Message.find {}, (err, messages) ->
    #         switch req.params.format
    #             # When json, generate suitable data
    #             when 'json' then res.send messages.map (d) -> return d.toObject();
    #             # default
    #             else res.send "you need to specify a format"

    # Read Single message
    # GET
    # Example: http://website/api/messages/5072c44f3d3ffb911a000de2
    app.get '/api/messages/:id', (req, res) ->
        
        # Get Only specific fields from Seurons in DB
        # ... not implemented

        Message.findById req.params.id, (err, message) ->
            res.json err if err
            res.json message 


        