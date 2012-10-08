mongoose = require("mongoose")
mongooseAuth = require('mongoose-auth');
everyauth = require('everyauth');

Schema = mongoose.Schema
ObjectId = mongoose.SchemaTypes.ObjectId

# Import API keys from config files
apikeys =  require '../../config/apikeys'


collection = "users"

UserSchema = new Schema (
    seuron_id : 
      type: ObjectId
      index: true
      ref: 'SeuronSchema' 
    date: Date
    twit: Object
)

UserSchema.methods.createWithTwitter = ( twitUserMeta, accessToken, accessTokenSecret, callback ) ->

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

    # info to store inside new User
    # params ={}
    @twit = twitterProfile

    # console.log params
    @save callback

###
This part contains all logic related to everyauth module.
People can log using twitter, then it retrieves the data 
and populate the user profile and the attached seuron
###

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
        redirectPath: '/fake/you'

        findOrCreateUser: (session, accessTok, accessTokSecret, twitterUser) ->

          promise = @Promise()
          User = @User()() # Fetch our User class back
          
          console.log  "------ we are looking for user with twitter id : " + twitterUser.id

          # Let's lookup our user using its twitter id
          User.findOne { "twit.id": Number twitterUser.id }, (err, foundUser) ->
              
              console.log err if err 

              console.log "---------------------- foundUser  = ", foundUser
              
              if foundUser 
                # A user has been founded into our db !
                # Let's see if its Twitter profile is up-to-date
                
                console.log "---------------------- existing user", foundUser.id
                
                # updateSeuronWithTwitter

                return promise.fail err if err
                promise.fulfill foundUser #login our user
              else 

                # Our user hasn't been founded so it is NOT a returning user
                # Let's create our user from its twitter credentials
                
                return promise.fail(err) if err # handle error

                console.log "---------------------- create a new user"

                # Import Seuron model so we can create a new Seuron with the new User
                Seuron = require('../models/Seuron').Seuron

                # Let's create our new user inside DB
                createdUser = new User

                # console.log createdUser
                # Call a method to populate data with Twitter
                createdUser.createWithTwitter twitterUser, accessTok, accessTokSecret, (err) ->
                  
                  console.log(err) if err

                  # Check if a Seuron already exists with the same user id
                  Seuron.findOne
                    "user_id" : createdUser._id, (err, foundSeuron) ->
                      console.log "seuronExists = ", foundSeuron

                      # If seuron doesn't already exists, then create it
                      if( foundSeuron == null)
                        #Create our new Seuron

                        s = new Seuron()  
                        # Add Twitter profile to our seuron
                        s.sns.twitter.id = createdUser.twit.id
                        s.sns.twitter.profile = createdUser.twit
                        # Attach a new Seuron to our user
                        s.user_id = createdUser._id

                        s.save ( d ) ->
                          console.log "new seuron created"
                          # Add our new seuron ID to user
                          createdUser.seuron_id = s._id

                          # Save our new user into DB
                          createdUser.save (err) ->
                            console.log(err) if err
                            console.log "user updated with seuron id"
                            #We can create our user session
                            return promise.fail(err) if err
                            promise.fulfill createdUser 

                      else 
                        # Our seuron already exists in the db
                        
                        # Update our seuron Twitter profile 
                        s.sns.twitter.profile = createdUser.twit
                        # Attach a new Seuron to our user
                        s.user_id = createdUser._id

                        # Save our seuron
                        s.save ( d ) ->
                          # Add our new seuron ID to user
                          createdUser.seuron_id = s._id

                          # Save our new user into DB
                          createdUser.save (err) ->
                            console.log(err) if err
                            console.log "New user updated with seuron id"
                            #We can now create our user session
                            return promise.fail(err) if err
                            promise.fulfill createdUser 

User = mongoose.model('User', UserSchema) 

module.exports = {
  User:User
}