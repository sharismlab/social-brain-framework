r = require 'redis'
c = require 'crypto'
config =  require '../../config/db'
redis  = null

( () ->

    queue = (if typeof exports isnt "undefined" then exports else root.queue = {})

    init = ->
        redis = r.createClient(config.redis.port, config.redis.host, config.redis.options)
        redis.debug_mode = true;

    unique = (string, callback) ->
        md5sum = c.createHash('md5')
        md5sum.update(string)
        hash = 'k:prefix' + md5sum.digest('hex').substring(0, 16)
        redis.exists hash, (err, flag) ->
              if !flag
                redis.set hash, '1'
                redis.expire hash, 600
              callback err, !flag

    enqueue = (key, o, callback) ->
        if o
            val = JSON.stringify o
            unique val, (err, flag) ->
               redis.rpush key, val if flag

    dequeue = (key, callback) ->
        redis.lpop key, (err, val) ->
            if err
                callback err, null
            else
                if val
                    callback null, JSON.parse val
                else
                    callback null, null

    fetchInfo = (key, callback) ->
        redis.lpop key, (err, value) ->
            if not err and value
                #console.log 'raw' + value
                callback err, JSON.parse(value)
            else
                callback null, null

    size = (key, callback) ->
        redis.llen key, (err, len) ->
          if not err and len
            console.log "queue length" : len
          else
            callback null, null

    # Exports to the outside world
    queue.init = init
    queue.enqueue = enqueue
    queue.dequeue = dequeue
    queue.fetchInfo = fetchInfo
    queue.size = size
    
    #export as node
    if typeof module isnt "undefined" and module.exports
          module.exports = queue
    else
          root.queue = queue
) this
