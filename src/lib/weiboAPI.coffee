# Here is stored all logic related to weibo API requests
#
# * We use node-weibo
# * Docs available here: https://github.com/fengmk2/node-weibo/blob/master/api.md


weibo = require 'weibo'
apikeys = require '../../config/apikeys'

# Global vars to store info & accesstoken from everyauth
user=null

init = (accessToken, userId) ->
    user = 
        blogtype : "weibo"
        access_token : accessToken
        uid : userId

    weibo.init 'weibo', apikeys.weibo.appKey, apikeys.weibo.appSecret, apikeys.weibo.oauth_callback_url

getPublicTimeline = (callback) ->
    weibo.public_timeline user, cursor, (err, statuses) ->
        console.error(err) if (err) 
        callback(statuses);

getTimeline = (callback) ->
    weibo.user_timeline user, (err, statuses) ->
        console.error(err) if (err) 
        callback(statuses);
      
getMentions = (cursor, callback) ->
    console.log weibo
    weibo.mentions user, cursor, (data) ->
        callback data

searchTerm = (query, callback) ->
    cursor = 
        count: 20
    weibo.search user, query, cursor, (err, statuses) ->
        callback statuses

# export methods
module.exports =
    init: init
    getTimeline: getTimeline
    getMentions: getMentions
    getPublicTimeline: getPublicTimeline
    searchTerm: searchTerm