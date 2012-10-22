# Here is stored all logic related to twitter API requests
# We use nTwitter module to fetch data from twitter


s = null
tok =null
tokSec=null

# create a ntwitter element
ntwitter = require 'ntwitter'
apikeys = require '../../config/apikeys'

# declare global vars
ntwit = null

#import seuron controller
# seurons_controller = require '../controllers/seurons_controller'

# use logged in user credentials to process requests
loginToTwitter = (tok, tokSec) ->
    console.log tok, tokSec

    ntwit = new ntwitter (    
        consumer_key: apikeys.twitter.consumerKey
        consumer_secret: apikeys.twitter.consumerSecret
        access_token_key: tok
        access_token_secret: tokSec
    )

# just to check if it works
verifyCredentials = () ->
    url = 'https://api.twitter.com/1.1/account/verify_credentials.json'
    ntwit.get url, null, (err,data) ->
        console.log err if err
        console.log(data);
    return

#
getFollowers = (seuron, callback) ->
    if( seuron.sns.twitter.hasFollowers.check == false || seuron.sns.twitter.hasFollowers.last_updated < Date.now+30000)
        console.log "get followers !"
        ntwit.getFollowersIds seuron.sns.twitter.id, (err, data) ->
            console.log err if err
            seuron.sns.twitter.followers = data
            seuron.sns.twitter.hasFollowers.check = true
            seuron.sns.twitter.hasFollowers.last_updated = new Date
            seuron.save (d) ->
                callback

getFriends = (seuron, callback) ->
    if( seuron.sns.twitter.hasFriends.check == false || seuron.sns.twitter.hasFriends.last_updated < Date.now+30000)
        ntwit.getFriendsIds seuron.sns.twitter.id, (err,data) ->
            console.log err  if err
            console.log "get friends !"
            seuron.sns.twitter.friends = data
            seuron.sns.twitter.hasFriends.check = true
            seuron.sns.twitter.hasFriends.last_updated = new Date
            seuron.save (d) ->
                callback

# Now let's get timeline and mentions
getTimeline = (callback) ->
    console.log "(get twitter timeline)"
    ntwit.getUserTimeline {"include_rts": true,"include_entities" : true, "count":200 }, (err,data) ->
        console.log err if err
        # console.log data
        callback(data)

getMentions = (callback) ->
    console.log "(get twitter mentions)"
    ntwit.get "/statuses/mentions_timeline.json", {"include_rts": true,"include_entities" : true, "count":200 }, (err,data) ->
        console.log err if err
        # console.log data
        callback(data)

lookupUsers = (ids, callback) ->
    console.log "need some users dude?"
    ntwit.lookupUsers ids, (err, data) ->
        console.log err if err
        console.log "you've got "+data.length+ "users..."
        callback data

# export methods
module.exports =
    ntwit : ntwit
    loginToTwitter : loginToTwitter
    verifyCredentials : verifyCredentials
    getFriends : getFriends
    getFollowers : getFollowers
    getTimeline : getTimeline
    getMentions : getMentions
    lookupUsers : lookupUsers