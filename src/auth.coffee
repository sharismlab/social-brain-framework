apikeys =  require '../config/apikeys'

module.exports = (app, mongoose, everyauth, mongooseAuth) ->

  auth = this 
  everyauth.debug = true;
  
  ## OAUTh
  Promise = everyauth.Promise

  # console.log Promise
  # console.log app.everyauth.twitter.configurable();

  # User model
  UserSchema = require('./models/User') mongoose
  mongoose.model('User', UserSchema)
  User = mongoose.model('User');

  #configure everyauth
  UserSchema.plugin mongooseAuth,
    everymodule:
      everyauth:
        User: ->
          User

    twitter:
      everyauth:
        myHostname: "http://local.host:3000"
        consumerKey: apikeys.twitter.consumerKey
        consumerSecret: apikeys.twitter.consumerSecret
        redirectPath: '/seuron'

        findOrCreateUser: (session, accessTok, accessTokSecret, twitterUser) ->
          promise = @Promise()
          #console.log  promise
          self = this 
          
          @User()().findOne 
            "twit.id": twitterUser.id # lookup our user using twitter ID
          , (err, foundUser) ->
            return promise.fail(err) if err # error !
            return promise.fulfill(foundUser) if foundUser # user has been founded into db !
            # console.log self.User()()

            self.User()().createWithTwitter twitterUser, accessTok, accessTokSecret, (err, createdUser) ->
              return promise.fail(err)  if err
              promise.fulfill createdUser # create our new user inside DB

          promise

  auth