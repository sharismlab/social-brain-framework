request = require 'request'
keys = require '../../config/apikeys'

# console.log(keys)

# Twitter OAuth
qs = require("querystring")

oauth =
  callback: "http://localhost:3000/callback/"
  consumer_key: keys.twitter.consumerKey
  consumer_secret: keys.twitter.consumerSecret

url = "https://api.twitter.com/oauth/request_token"

oauth

###
request.post
  url: url
  oauth: oauth
, (e, r, body) ->
  
  # Assume by some stretch of magic you aquired the verifier
  access_token = qs.parse(body)
  oauth = 
      consumer_key: keys.twitter.consumerKey
      consumer_secret: keys.twitter.consumerSecret
      token: keys.twitter.tokenKey
      token_secret: keys.twitter.tokenecret
      verifier: 1231321
  url = "https://api.twitter.com/oauth/access_token"

  request.post
    url: url
    oauth: oauth
  , (e, r, body) ->
    perm_token = qs.parse(body)
    oauth =
      consumer_key: keys.twitter.consumerKey
      consumer_secret: keys.twitter.consumerSecret
      token: perm_token.oauth_token
      token_secret: perm_token.oauth_token_secret

    url = "https://api.twitter.com/1/users/show.json?"
    # url = "https://api.twitter.com/1/account/rate_limit_status.json"
    params =
      screen_name: perm_token.screen_name
      user_id: perm_token.user_id

    url += qs.stringify(params)
    request.get
      url: url
      oauth: oauth
      json: true
    , (e, r, user) ->
      console.log user



