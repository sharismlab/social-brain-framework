r = require 'redis'
c = require 'crypto'
config =  require '../../config/db'
redis  = null

( () ->

    queue = (if typeof exports isnt "undefined" then exports else root.queue = {})

    init = ->
        redis = r.createClient(config.redis.port, config.redis.host, config.redis.options)
        redis.debug_mode = true;

    unique = (key, callback) ->
        redis.exists key, (err, flag) ->
              if !flag
                redis.set key, '1'
                redis.expire key, 600
              callback err, !flag

    enqueue = (key, o) ->
        if o
            val = JSON.stringify o
            console.log 'key : ---->' + key
            console.log redis.offline_queue.length
            if redis.exists key
               redis.rpush key val
               console.log "exists"
            else
               console.log "doesn't exists"
               redis.set key
               redis.rpush key, val
               # redis.expire key, 600

    dequeue = (key, callback) ->
        redis.lpop key, (err, val) ->
            if err
                callback err, null
            else
                if val
                    callback null, JSON.parse val
                else
                    callback null, null

    fetchMessage = (key, callback) ->
        redis.lpop key, (err, value) ->
            if not err and value
                # console.log 'raw' + value
                callback err, JSON.parse(value)
            else
                callback null, null

    size = (key, callback) ->
        redis.llen key, callback


    # Exports to the outside world
    queue.init = init
    queue.enqueue = enqueue
    queue.dequeue = dequeue
    queue.fetchMessage = fetchMessage
    queue.size = size
    
    #export as node
    if typeof module isnt "undefined" and module.exports
          module.exports = queue
    else
          root.queue = queue
) this
