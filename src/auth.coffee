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
          User = @User()()
          
          console.log  "------ we are looking for user with twitter id : " + twitterUser.id
          # screenName = new RegExp("^#{RegExp.escape twit.screen_name}$", 'i')
          
          # lookup our user using twitter id
          User.findOne 
            'twit.id': twitterUser.id ,
            (err, foundUser) ->
              console.log "---------------------- foundUser  = ", foundUser
              
              if foundUser 
                # user has been founded into db !
                console.log "---------------------- existing user", foundUser.id
                # updateSeuronWithTwitter
                return promise.fail err if err
                promise.fulfill foundUser 
              
              else 
                # handle error
                return promise.fail(err) if err 

                # return promise.fulfill(id: null) unless foundUser
                console.log "---------------------- create a new user"

                #Import seuron model
                SeuronSchema = require('./models/Seuron') mongoose
                mongoose.model('Seuron', SeuronSchema)
                Seuron = mongoose.model('Seuron') 
                
                createdUser = new User
                # console.log createdUser

                # createdUser = new self.User()()
                # if not founded, create our new user inside DB
                createdUser.createWithTwitter twitterUser, accessTok, accessTokSecret, (err) ->
                  
                  console.log(err) if err
                
                  # @User()().findOne "twit.id": twitterUser.id , (err, createdUser) ->
                  console.log "----------------- user "
                  console.log createdUser

                  #lookup if the seuron already exists in db
                  Seuron.findOne
                    "s.user_id" : createdUser._id, (err, foundSeuron) ->
                      console.log "seuronExists = ", foundSeuron 

                      if( foundSeuron == null)
                        #create new Seuron
                        s = new Seuron()  # attach a new Seuron to our user
                        s.sns.twitter.profile = createdUser.twit
                        s.user_id = createdUser._id

                        s.save ( d ) ->
                          console.log "new seuron created"
                          createdUser.seuron_id = s._id

                          createdUser.save (err) ->
                            console.log(err) if err
                            console.log "user updated with seuron id"

                #create user session
                return promise.fail(err) if err
                promise.fulfill createdUser 
              
          promise

  auth