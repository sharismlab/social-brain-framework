# queue = require "../lib/redis_queue"

Seuron = require ('../models/Seuron').Seuron

findOrCreateSeuronWithTwitterId = (twitterId, callback) ->
  
  Seuron.findOne {"sns.twitter.id": twitterId}, (err, seuron) ->
    console.log err if err
    if !seuron
      s = new Seuron
      s.sns.twitter.id= twitterId
      s.save (d) ->
        callback(d)
    else
      callback(seuron)

getFollowersFromTwitter = (ntwit,seuron, callback) ->
    ntwit.getFollowersIds seuron.sns.twitter.profile.id, (err, data) ->
        if err
          console.log err
        else
          seuron.sns.twitter.followers = data
          seuron.sns.twitter.hasFollowers.check = true
          seuron.sns.twitter.hasFollowers.last_updated = Date.now
          seuron.save()
          callback(  err,data )
            
getFriendsFromTwitter = (ntwit,seuron, callback) ->
    console.log 'get firends from twitter account '+ seuron.sns.twitter.profile.id
    ntwit.getFriendsIds seuron.sns.twitter.profile.id, (err,data) ->
          if err
            console.log err 
          else 
            # add data to seuron 
            seuron.sns.twitter.friends = data
            seuron.sns.twitter.hasFriends.check = true
            seuron.sns.twitter.hasFriends.last_updated = Date.now
            seuron.save()
            callback err,data  

# Now let's get timeline and mentions
getTimelineFromTwitter = (ntwit, callback)->
    console.log "(get twitter timeline)"
    ntwit.getUserTimeline {"include_rts": true,"include_entities" : true, "count":200 }, (err,data) ->
        console.log err if err
        # console.log data
        callback( err, data )



module.exports = {
      getFollowersFromTwitter : getFollowersFromTwitter,
      getFriendsFromTwitter : getFriendsFromTwitter,
      getTimelineFromTwitter : getTimelineFromTwitter,
      findOrCreateSeuronWithTwitterId: findOrCreateSeuronWithTwitterId
    }