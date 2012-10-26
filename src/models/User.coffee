mongoose = require "mongoose"
mongooseAuth = require 'mongoose-auth'
#Let's configure everyauth
everyauth = require 'everyauth'
everyauth.debug = true

troop = require 'mongoose-troop' #plugins


Schema = mongoose.Schema
ObjectId = mongoose.SchemaTypes.ObjectId

# Import API keys from config files
apikeys =  require '../../config/apikeys'

# mongoose.set('debug', true)

collection = "users"

UserSchema = new Schema (

    seuron_id : 
      type: ObjectId
      index: true
      ref: 'SeuronSchema' 
    
    twitter: 
      # accessToken:String
      # accessTokenSecret:String
      id: String
      name: String
      screenName: String
      location: String
      description:String
      profileImageUrl: String
      url:String
    
    weibo: 
      # accessToken: String
      id: String
      name: String
      screenName: String
      location: String
      description: String
      profileImageUrl: String
      url: String
  )

UserSchema.plugin(troop.timestamp)

UserSchema.methods.populateWithTwitter = ( twitUserMeta, callback ) ->

    twitterProfile =
        # accessToken: accessToken
        # accessTokenSecret: accessTokenSecret
        id: String(twitUserMeta.id)
        name: twitUserMeta.name
        screenName: twitUserMeta.screen_name
        location: twitUserMeta.location
        description: twitUserMeta.description
        profileImageUrl: twitUserMeta.profile_image_url
        url: twitUserMeta.url

    # info to store inside new User
    # params ={}
    @twitter = twitterProfile

    # console.log params
    @save callback

UserSchema.methods.populateWithWeibo = ( weiboMeta, callback) ->
  # console.log "createWithWeibo"
  weiboProfile = 
    # accessToken: accessToken
    id: String(weiboMeta.id)
    name: weiboMeta.name
    screenName: weiboMeta.screen_name
    location: weiboMeta.location
    description: weiboMeta.description
    profileImageUrl: weiboMeta.profile_image_url
    url: weiboMeta.url
    

  @weibo = weiboProfile
  @save callback

lookForExistingTwitterUsername = (username, callback) ->
    User.findOne {"twit.screenName":username} , (err, foundUser) ->
    callback (foundUser)

lookForExistingWeiboUsername = (username, callback) ->
    User.findOne {"weibo.screenName":username} , (err, foundUser) ->
    callback (foundUser)

UserSchema.methods.mergeUser = (user2, callback) ->

###
This part contains all logic related to everyauth module.
People can log using twitter, then it retrieves the data 
and populate the user profile and the attached seuron
###

# createAndLinkToSeuron (service, data, callback)
#
# This function is called when one login or register using an sns account
#
# * Service is the name of the service lowercase without space (twitter,weibo, etc.)
# * Data is the complete profile from sns API
# * Callback returns a new User linked to a seuron

# Import Seuron model so we can create a new Seuron with the new User
Seuron = require('../models/Seuron').Seuron

UserSchema.statics.createAndLinkToSeuron = (service, data, callback) ->
  # console.log data

  createdUser = new User
  Seuron.findOne service+'.id': data.id, (err, foundSeuron) ->
    console.log err if err # handle error
    # console.log "seuronExists = ", foundSeuron
    # If seuron doesn't already exists, then create it
    if( foundSeuron == null)
      s = new Seuron  
      s.user_id = createdUser._id # Link user to our seuron
      
      if service == "twitter" 
        s.populateWithTwitter data, () ->
          console.log 'added twitter data'
      else if service == "weibo" 
        s.populateWithWeibo data, () ->
          console.log 'added weibo data'

      s.save (err) ->
        console.log(err) if err
        # console.log s
        createdUser.seuron_id = s._id # Link new seuron to our user
        createdUser.save (err) ->
          console.log(err) if err
          callback(createdUser)
    else
      foundSeuron.user_id = createdUser._id # Link user to our seuron

      if service == "twitter" 
        foundSeuron.populateWithTwitter data, () ->
          console.log 'added twitter data'
      else if service == "weibo" 
        foundSeuron.populateWithWeibo data, () ->
          console.log 'added weibo data'

      foundSeuron.save () ->
        # Add our new seuron ID to user
        createdUser.seuron_id = foundSeuron._id
        # Save our new user into DB
        createdUser.save (err) ->
          console.log(err) if err
          callback(createdUser)


Promise = everyauth.Promise
# mongoose.set('debug', true)

UserSchema.plugin mongooseAuth,
    everymodule:
      everyauth:
        User: ->
          User #We specify here the class that should be used by Everyauth
          
    twitter:
      everyauth:
        myHostname: apikeys.twitter.url
        consumerKey: apikeys.twitter.consumerKey
        consumerSecret: apikeys.twitter.consumerSecret
        # callbackPath: apikeys.twitter.callbackPath
        redirectPath: apikeys.twitter.redirectUrl

        findOrCreateUser: (session, accessTok, accessTokSecret, twitterUser) ->

          promise = @Promise()
          User = @User()() # Fetch our User class back
          
          # Let's lookup our user using its twitter id
          User.findOne { "twitter.id": twitterUser.id }, (err, foundUser) ->
              return promise.fail err if err
              if foundUser
                console.log "found twitter user !"
                promise.fulfill foundUser 
              else
                User.createAndLinkToSeuron "twitter", twitterUser, (createdUser)->
                  console.log "created !"
                  createdUser.populateWithTwitter twitterUser, () ->
                    console.log "populated !"
                    promise.fulfill createdUser

    weibo:
      everyauth:
        appId: apikeys.weibo.appKey
        appSecret: apikeys.weibo.appSecret
        redirectPath : apikeys.weibo.redirectUrl

        findOrCreateUser: (session, accessToken, appSecret, weiboUser) ->
          # console.log weiboUser

          promise = @Promise()
          User = @User()()

          User.findOne {'weibo.id': weiboUser.id}, (err, foundUser) ->
              return promise.fail err if err
              if foundUser
                promise.fulfill foundUser 
              else
                User.createAndLinkToSeuron "weibo", weiboUser, (createdUser)->
                  createdUser.populateWithWeibo weiboUser, () ->
                    promise.fulfill createdUser

User = mongoose.model('User', UserSchema) 

module.exports = 
  User:User
