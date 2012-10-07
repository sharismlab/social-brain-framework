# Here is stored all logic related to twitter API requests
# We use nTwitter module to fetch data from twitter


s = null
tok =null
tokSec=null

# create a ntwitter element
ntwitter = require 'ntwitter'
apikeys = require '../../config/apikeys'

# decalre global vars
# timeline = null

module.exports = (tok, tokSec) ->

    twitterAPI = this

    console.log tok, tokSec
    
    #use logged in user credentials to process requests
    ntwit = new ntwitter (    
        consumer_key: apikeys.twitter.consumerKey
        consumer_secret: apikeys.twitter.consumerSecret
        access_token_key: tok
        access_token_secret: tokSec
    )

    verifyCredentials = () ->        
        url = 'https://api.twitter.com/1.1/account/verify_credentials.json'
        ntwit.get url, null, (err,data) ->
            console.log err if err
            console.log(data);
        return


    #basic function to pass data from async to socket
    # passToSocket = (name, data ) ->
    #     console.log "passed data ---------------------------------------------"
    #     console.log data
    #     socket.emit name, { data: data }

    # export methods 
    twitterAPI.verifyCredentials = verifyCredentials
    twitterAPI.ntwit = ntwit

    #Export as node
    twitterAPI