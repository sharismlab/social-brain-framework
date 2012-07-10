queue = require './queue'

# import hyve crawler 
hyve = require('./src/hyve.core.js')
require('./src/hyve.twitter.js')
require('./src/hyve.facebook.js')

# hyve setup
hyve.queue_enable = true
hyve.recall_enable = false

queue.init()
mydis  = this

gap = 30000 # 30 seconds

( () ->
    crawler = (if typeof exports isnt "undefined" then exports else root.crawler = {})

    check = ->
            queue.size (err, len) -> #check the length of redis queue
                if not err and len >= 0
                    gap = 100 * len
            setTimeout(check, 10000)


    uniqueId = (length=8) ->
      id = ""
      id += Math.random().toString(36).substr(2) while id.length < length
      id.substr 0, length

    search = (searchquery, sns) ->
           console.log "search term :  " + searchquery
           key = uniqueId(10)
           prefix = 'k:search:'
           hyve.search.stream searchquery, ( (snsdata) ->
                item = hyve.queue.text[0]       # get first item from hyve queue
                queue.enqueue key,item          # enqueue in redis
                console.log 'balababababab'
                queue.size key
               #mydom.emit searchresults        # dequeue from hyve
           ), sns
           key

    # console.log search
    # Exports to the outside world
    crawler.check = check
    crawler.search = search
    
    #export as node
    if typeof module isnt "undefined" and module.exports
          module.exports = crawler
    else
          root.crawler = crawler
) this
