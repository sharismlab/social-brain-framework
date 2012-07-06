queue = require './queue'

# import hyve crawler 
hyve = require('./src/hyve.core.js')
require('./src/hyve.twitter.js')
require('./src/hyve.facebook.js')

# hyve setup
hyve.queue_enable = true
hyve.recall_enable = false

console.log "loading crawler module"

queue.init()

gap = 30000 # 30 seconds

( () ->
    crawler = (if typeof exports isnt "undefined" then exports else root.crawler = {})

    check = ->
            queue.size (err, len) -> #check the length of redis queue
                if not err and len >= 0
                    gap = 100 * len
            setTimeout(check, 10000)

    search = (searchquery) ->
           key    = 'q:search'
           prefix = 'k:'+ searchquery +":"
           hyve.search.stream searchquery, ( (snsdata) ->
                item = hyve.queue.text[0]       # get first item from hyve queue
                queue.enqueue item              # enqueue in redis
                mydom.emit searchresults        # dequeue from hyve
           ), [ "twitter", "facebook" ]

    # Exports to the outside world
    crawler.check = check
    crawler.search = search
    
    #export as node
    if typeof module isnt "undefined" and module.exports
          module.exports = crawler
    else
          root.crawler = crawler
) this
