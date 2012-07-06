r = require 'redis'
c = require  'crypto'
config =  require '../../config/db'
redis  = null

console.log "loading queue module"

( () ->

    queue = (if typeof exports isnt "undefined" then exports else root.queue = {})

    init = ->
        redis = r.createClient(config.redis.port, config.redis.host, config.redis.options)

    unique = (s, callback) ->
        md5sum = c.createHash('md5')
        md5sum.update(s)
        hash = prefix + md5sum.digest('hex').substring(0, 16)
        redis.exists hash, (err, flag) ->
            if !flag
                redis.set hash, '1'
                redis.expire hash, 600
            callback err, !flag

    enqueue = (o) ->
        if o
            val = JSON.stringify o
            unique val, (err, flag) ->
                redis.rpush key, val if flag

    dequeue = (callback) ->
        redis.lpop key, (err, val) ->
            if err
                callback err, null
            else
                if val
                    callback null, JSON.parse val
                else
                    callback null, null

    fetchText = (callback) ->
        redis.lpop key, (err, value) ->
            if not err and value
                callback err, JSON.parse(value).text
            else
                callback null, null

    size = (callback) ->
        redis.llen key, callback
        
        
    # Exports to the outside world
    queue.init = init
    queue.enqueue = enqueue
    queue.dequeue = dequeue
    queue.fetchText
    queue.size = size
    
    #export as node
    if typeof module isnt "undefined" and module.exports
          module.exports = queue
    else
          root.queue = queue
) this
