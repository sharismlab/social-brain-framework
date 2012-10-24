# Here is stored all logic related to weibo API requests
#
# * We use node-weibo
# * Docs available here: https://github.com/fengmk2/node-weibo/blob/master/api.md


weibo = require 'weibo'

apikeys = require '../../config/apikeys'
weibo.init('weibo', apikeys.weibo.appKey, apikeys.weibo.appSecret);

getMentions = (user, cursor, callback) ->
    weibo.mentions user, cursor, (data) ->
        console.log data

# export methods
module.exports =
    getMentions: getMentions