mongoose = require("mongoose")

collection = "Seurons"

Schema = mongoose.Schema
ObjectId = mongoose.SchemaTypes.ObjectId

seuronSchema = new Schema(
    created_at: Date
    updated_at: Date
    username: String
    user_id : 
      type: ObjectId
      index : true
      ref: 'UserSchema'
    sns: 
      twitter: 
        profile : Object
        timeline: Array
        mentions: Array
        followers: Array
        friends: Array

        hasTimeline : 
          check :
            type: Boolean
            default: false
          last_updated: 
            type : Date
            default: Date.now
        
        hasMentions : 
          check :
            type: Boolean
            default: false
          last_updated: 
            type : Date
            default: Date.now

        hasFollowers : 
          check :
            type: Boolean
            default: false
          last_updated: 
            type : Date
            default: Date.now

        hasFriends :
          check :
            type: Boolean
            default: false
          last_updated: 
            type : Date
            default: Date.now
)

# seuronSchema.pre('save', callback)

seuronSchema.methods.hasProfile = ->
    ret = false
    if(this.sns.twitter.profile)
      console.log "has already a profile"
      ret=true
    ret

seuronSchema.methods.hasTimeline = ->
    ret = false
    console.log(this.sns.twitter.timeline.length)
    if( this.sns.twitter.timeline.length > 1 )
      console.log "has already timeline"
      ret = true
    ret

seuronSchema.methods.hasMentions = ->
    ret = false
    console.log(this.sns.twitter.mentions.length)
    if( this.sns.twitter.mentions.length > 1 )
      console.log "has already mentions"
      ret = true
    ret

seuronSchema.methods.hasFriends = ->
    ret = false
    # console.log(this.sns.twitter.friends)
    if(this.sns.twitter.friends.length>1)
      console.log "has already a friends"
      ret=true
    ret

seuronSchema.methods.hasFollowers = ->
    ret =false
    if(this.sns.twitter.followers.length>1)
      console.log "has already followers"
      ret=true
    ret

#get user timeline
seuronSchema.methods.getTimelineFromTwitter = (ntwit, callback) ->
    seuron = this
    ntwit.getUserTimeline {"include_rts": true,"include_entities" : true, "count":200 }, 
      (err,data) ->
          console.log err if err
          # add data to seuron 
          seuron.sns.twitter.timeline = data
          seuron.sns.twitter.hasTimeline.check = true
          seuron.sns.twitter.hasTimeline.date = Date.now
          seuron.save()
          callback( err,data )
    return 

#get user timeline
seuronSchema.methods.getMentionsFromTwitter = (ntwit, callback) ->
    seuron = this
    ntwit.getMentions {"include_rts": true,"include_entities" : true, "count":200 }, 
      (err,data) ->
          console.log err if err
          # add data to seuron 
          seuron.sns.twitter.mentions = data
          seuron.sns.twitter.hasMentions.check = true
          seuron.sns.twitter.hasMentions.date = Date.now
          seuron.save()
          callback( err,data )
    return 

#getUserFriends
seuronSchema.methods.getFriendsFromTwitter = (ntwit, callback) ->
    seuron = this
    ntwit.getFriendsIds this.sns.twitter.profile.id, (err,data) ->
          console.log err if err
          # add data to seuron 
          seuron.sns.twitter.friends = data
          seuron.sns.twitter.hasTimeline.check = true
          seuron.sns.twitter.hasTimeline.date = Date.now
          seuron.save()
          callback( err,data  )
    return

#get User Followers
seuronSchema.methods.getFollowersFromTwitter = (ntwit, callback) ->
    seuron = this 
    ntwit.getFollowersIds this.sns.twitter.profile.id, (err, data) ->
        console.log err if err
        seuron.sns.twitter.followers = data
        seuron.sns.twitter.hasTimeline.check = true
        seuron.sns.twitter.hasTimeline.date = Date.now
        seuron.save()
        callback(  err,data )
    return

#get mentions timeline
# # seuronSchema.methods.getMentionsFromTwitter = (ntwit, callback) ->        
#     ntwit.getMentions {"include_rts": true, "include_entities" : true, "count" : 200 }, 
#       (err,data) ->
#           console.log err if err
#           # passToSocket( "mentions", data)
#     callback()


Seuron = mongoose.model('Seuron', seuronSchema)

module.exports = {
  Seuron:Seuron
}