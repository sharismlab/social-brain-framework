###
store all twitter API requests
for call by socket.io
###

s = null
tok =null
tokSec=null

# create a ntwitter element
ntwitter = require 'ntwitter'
apikeys = require '../../config/apikeys'

# decalre global vars
# timeline = null

module.exports = () ->

    twitterAPI = this

    # twidata = req.session.auth.twitter.user.id
    # tok = req.session.auth.twitter.token
    # tokSec = req.session.auth.twitter.tokenSecret

    #use logged in user credentials to process requests
    ntwit = new ntwitter (    
        consumer_key: apikeys.twitter.consumerKey
        consumer_secret: apikeys.twitter.consumerSecret
        access_token_key: apikeys.twitter.tokenKey
        access_token_secret: apikeys.twitter.tokenSecret
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