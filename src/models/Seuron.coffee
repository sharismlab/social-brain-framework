# This is the seuron class
# A Seuron intends to store info about a specific user from different social networks.
# All relationships are stored in an Array of Synapses that connects it to other seurons.


mongoose = require "mongoose"
troop = require 'mongoose-troop'

collection = "Seurons"

Schema = mongoose.Schema
ObjectId = mongoose.SchemaTypes.ObjectId

SeuronSchema = new Schema
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
        id : { type: Number, index: { unique: true } }
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
      weibo: 
        id : { type: Number, index: { unique: true } }
        profile : Object

SeuronSchema.plugin(troop.timestamp)

# SeuronSchema.pre('save', callback)


# Import Synpase model
Synapse = require('../models/Synapse').Synapse

# create a synapse between this seuron and the Seuron passed
# adding to friendship level
SeuronSchema.methods.createSynapse = ( seuron, callback ) ->

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
SeuronSchema.methods.findOrCreateSynapse = ( seuron, callback ) ->
  
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
SeuronSchema.methods.isFriend = ( twitter_id ) ->
  i = 0
  # console.log @sns.twitter.friends
  while @sns.twitter.friends[i]
    return true if @sns.twitter.friends[i] is twitter_id
    i++
  false

# check if a seuron is one of my followers
# return boolean 
SeuronSchema.methods.isFollower = ( twitter_id) ->
  i = 0
  while @sns.twitter.followers[i]
    return true if @sns.twitter.followers[i] is twitter_id
    i++
  false

## Data Functions
SeuronSchema.methods.hasProfile = ->
    ret = false
    if(this.sns.twitter.profile)
      console.log "has already a profile"
      ret=true
    ret

SeuronSchema.methods.hasFriends = ->
    ret = false
    # console.log(this.sns.twitter.friends)
    if(this.sns.twitter.friends.length>1)
      console.log "has already a friends"
      ret=true
    ret

SeuronSchema.methods.hasFollowers = ->
    ret =false
    if(this.sns.twitter.followers.length>1)
      console.log "has already followers"
      ret=true
    ret

SeuronSchema.methods.populateWithTwitter = ( twitUserMeta, callback ) ->

    twitterProfile =
        accessToken: accessToken
        accessTokenSecret: accessTokenSecret
        id: String(twitUserMeta.id)
        name: twitUserMeta.name
        screenName: twitUserMeta.screen_name
        location: twitUserMeta.location
        description: twitUserMeta.description
        profileImageUrl: twitUserMeta.profile_image_url
        url: twitUserMeta.url
        protected: twitUserMeta.protected
        followersCount: twitUserMeta.followers_count
        profileBackgroundColor: twitUserMeta.profile_background_color
        profileTextColor: twitUserMeta.profile_text_color
        profileLinkColor: twitUserMeta.profile_link_color
        profileSidebarFillColor: twitUserMeta.profile_sidebar_fill_color
        profileSiderbarBorderColor: twitUserMeta.profile_sidebar_border_color
        friendsCount: twitUserMeta.friends_count
        createdAt: twitUserMeta.created_at
        favouritesCount: twitUserMeta.favourites_count
        utcOffset: twitUserMeta.utc_offset
        timeZone: twitUserMeta.time_zone
        profileBackgroundImageUrl: twitUserMeta.profile_background_image_url
        profileBackgroundTile: twitUserMeta.profile_background_tile
        profileUseBackgroundImage: twitUserMeta.profile_use_background_image
        geoEnabled: twitUserMeta.geo_enabled
        verified: twitUserMeta.verified
        statusesCount: twitUserMeta.statuses_count
        lang: twitUserMeta.lang
        contributorsEnabled: twitUserMeta.contributors_enabled

    # store info inside Seuron
    @sns.twitter.profile = twitterProfile
    @sns.twitter.id = String(twitUserMeta.id)
    @save callback

SeuronSchema.methods.populateWithWeibo = ( weiboUserMeta, callback ) ->

    weiboProfile =
        id: String(weiboUserMeta.id)
        name: weiboUserMeta.name
        screenName: weiboUserMeta.screen_name
        location: weiboUserMeta.location
        description: weiboUserMeta.description
        profileImageUrl: weiboUserMeta.profile_image_url
        url: weiboUserMeta.url
        protected: weiboUserMeta.protected
        followersCount: weiboUserMeta.followers_count
        profileBackgroundColor: weiboUserMeta.profile_background_color
        profileTextColor: weiboUserMeta.profile_text_color
        profileLinkColor: weiboUserMeta.profile_link_color
        profileSidebarFillColor: weiboUserMeta.profile_sidebar_fill_color
        profileSiderbarBorderColor: weiboUserMeta.profile_sidebar_border_color
        friendsCount: weiboUserMeta.friends_count
        createdAt: weiboUserMeta.created_at
        favouritesCount: weiboUserMeta.favourites_count
        utcOffset: weiboUserMeta.utc_offset
        timeZone: weiboUserMeta.time_zone
        profileBackgroundImageUrl: weiboUserMeta.profile_background_image_url
        profileBackgroundTile: weiboUserMeta.profile_background_tile
        profileUseBackgroundImage: weiboUserMeta.profile_use_background_image
        geoEnabled: weiboUserMeta.geo_enabled
        verified: weiboUserMeta.verified
        statusesCount: weiboUserMeta.statuses_count
        lang: weiboUserMeta.lang
        contributorsEnabled: weiboUserMeta.contributors_enabled

    # store info inside Seuron
    @sns.weibo.profile = weiboProfile
    @sns.weibo.id = String(weiboUserMeta.id)
    @save callback

Seuron = mongoose.model('Seuron', SeuronSchema)

module.exports = {
  Seuron:Seuron
}