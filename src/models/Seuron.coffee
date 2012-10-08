# This is the seuron class
# A Seuron intends to store info about a specific user from different social networks.
# All relationships are stored in an Array of Synapses that connects it to other seurons.


mongoose = require("mongoose")

collection = "Seurons"

Schema = mongoose.Schema
ObjectId = mongoose.SchemaTypes.ObjectId

seuronSchema = new Schema
    created_at: Date
    updated_at: Date
    username: String

    user_id : 
      type: ObjectId
      index : true
      ref: 'UserSchema'
    
    # here are stored all objects describing relationships
    synapses: Array

    # all messages extracted from timeline
    messages: Array

    # Here are stored all infos extracted from social networks
    sns: 
      # Let's start with twitter
      twitter:
        id : { type: Number, required: true, index: { unique: true } }
        profile : Object # straight from Twitter
        # store all ids from twitter API
        followers: Array
        friends: Array

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

# seuronSchema.pre('save', callback)


# Import Synpase model
Synapse = require('../models/Synapse').Synapse

# create a synapse between this seuron and the Seuron passed
# adding to friendship level
seuronSchema.methods.createSynapse = ( seuron, callback ) ->

  # console.log @isFollower seuron.sns.twitter.profile.id
  daddy=this

  level = 0

  if @isFriend seuron.sns.twitter.id && @isFollower seuron.sns.twitter.id
    level = 1
  else if @isFriend seuron.sns.twitter.id
    level = 2
  else if @isFollower seuron.sns.twitter.id
    level = 3
  else
    level = 4
  
  # console.log "ids---------"
  # console.log @sns.twitter.id
  # console.log seuron.sns.twitter.id
  # console.log "ids---------"


  # Create our synapse
  syn = new Synapse {
    "seuronA.__id" : @,
    "seuronB.__id" : seuron,
    "seuronA.twitterId" : @sns.twitter.id,
    "seuronB.twitterId" : seuron.sns.twitter.id,
    "level" : level,
    "service" : "Twitter"
  }

  # console.log syn
  syn.save (err) ->
    
    # console.log err
    # console.log 'synapse created'

    # store synapses inside our seurons
    daddy.synapses.push syn
    
    daddy.save (d) ->
      callback (syn)

# return existing relationship (Synapse) based on another Seuron id
seuronSchema.methods.findOrCreateSynapse = ( seuron, callback ) ->
  
  # console.log seuron
  i = 0
  while @synapses[i]
    # console.log "synapse-- "+seuron.sns.twitter.id
    if seuron != @
      if @synapses[i].seuronB.twitterId is seuron.sns.twitter.id
        callback @synapses[i]
    i++

  @createSynapse seuron, callback

# check if a seuron is a friend of mine
# return boolean 
seuronSchema.methods.isFriend = ( twitter_id ) ->
  i = 0
  # console.log @sns.twitter.friends
  while @sns.twitter.friends[i]
    return true if @sns.twitter.friends[i] is twitter_id
    i++
  false

# check if a seuron is one of my followers
# return boolean 
seuronSchema.methods.isFollower = ( twitter_id) ->
  i = 0
  while @sns.twitter.followers[i]
    return true if @sns.twitter.followers[i] is twitter_id
    i++
  false


## Data Functions
seuronSchema.methods.hasProfile = ->
    ret = false
    if(this.sns.twitter.profile)
      console.log "has already a profile"
      ret=true
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


Seuron = mongoose.model('Seuron', seuronSchema)

module.exports = {
  Seuron:Seuron
}