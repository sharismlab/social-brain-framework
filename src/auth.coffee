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
        myHostname: apikeys.twitter.url
        consumerKey: apikeys.twitter.consumerKey
        consumerSecret: apikeys.twitter.consumerSecret
        redirectPath: '/seuron'

        findOrCreateUser: (session, accessTok, accessTokSecret, twitterUser) ->
          promise = @Promise()
          # console.log  twitterUser
          self = this 

          
          # lookup our user using twitter ID
          @User()().findOne 
            "twit.id": twitterUser.id , (err, foundUser) ->
              console.log "user found", foundUser

              # handle error !
              return promise.fail(err) if err 

              # user has been founded into db !
              if foundUser != null
                console.log "exsiting user", foundUser
                return promise.fulfill( foundUser )

              else
                #Import seuron model
                SeuronSchema = require('./models/Seuron') mongoose
                mongoose.model('Seuron', SeuronSchema)
                Seuron = mongoose.model('Seuron') 

                # if not founded, create our new user inside DB
                self.User()().createWithTwitter twitterUser, accessTok, accessTokSecret, (err, createdUser) ->
                  console.log(err) if err
                  # console.log( Seuron )

                  #lookup if the seuron already exists in db
                  Seuron.findOne 
                    "s.user_id" : createdUser._id, (err, foundSeuron) ->
                      console.log "seuron found", foundSeuron 

                      if( foundSeuron == null)
                        #create new Seuron
                        s = new Seuron()  # attach a new Seuron to our user
                        s.sns.twitter.profile = createdUser.twit
                        s.user_id = createdUser._id

                        s.save ( d ) ->
                          console.log "new seuron created"
                          console.log d
                          createdUser.seuron_id = s._id
                          createdUser.save (data) ->
                            console.log "user updated with seuron id"

                  #create user session
                  return promise.fail(err) if err
                  promise.fulfill createdUser 

          promise

  auth