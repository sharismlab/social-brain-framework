apikeys =  require '../config/apikeys'

module.exports = (app, mongoose, everyauth, mongooseAuth) ->
  
  # console.log everyauth
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

            # create our new user inside DB
            self.User()().createWithTwitter twitterUser, accessTok, accessTokSecret, (err, createdUser) ->
              console.log(err) if err
              console.log( Seuron )

              # create 

              #Import seuron model
              SeuronSchema = require('./models/Seuron') mongoose
              mongoose.model('Seuron', SeuronSchema)
              Seuron = mongoose.model('Seuron');

              s = new Seuron()  # attach a new Seuron to our user
              s.sns.twitter.profile = createdUser.twit
              s.user_id = createdUser._id

              s.save () ->
                console.log "new seuron created"
                # console.log data
                createdUser.seuron_id = s._id
                createdUser.save (data) ->
                  console.log "user updated with seuron id"


              #create user session
              return promise.fail(err) if err
              promise.fulfill createdUser 

          promise

  auth