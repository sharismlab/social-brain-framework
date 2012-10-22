# ## Check implementation of Alchemy API to node in Github
# https://github.com/framingeinstein/node-alchemy

AlchemyAPI = require 'alchemy-api'
apikeys = require '../../config/apikeys'

alchemy = new AlchemyAPI apikeys.alchemy.key

analyzeSentiment = (text, callback) ->
    alchemy.sentiment text, {}, (err, response) ->
        console.log err if err
        sentiment = null
        if response == null
            console.log "sentiment unknown" 
        else
            # See http://www.alchemyapi.com/api/ for format of returned object
            sentiment = response.docSentiment if response
            # Do something with data
            # console.log sentiment
            callback(sentiment)

extractEntities = (text, callback) ->
    alchemy.entities text, {}, (err, response) ->
        throw err if err
        # See http://www.alchemyapi.com/api/entity/htmlc.html for format of returned object
        entities = response.entities
        callback(entities)


# export methods
module.exports =
    alchemy : alchemy
    analyzeSentiment : analyzeSentiment
    extractEntities : extractEntities
