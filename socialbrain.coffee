zappa = require 'zappajs'
apikeys = require('./config/apikeys')
config =  require './config/db'
r = require 'redis'
m = 'exports'

#import crawler
crawler = require './lib/crawler/crawler'
queue = require './lib/crawler/queue'

console.log(crawler)

# let's go!
zappa 'localhost', 3000, ->

        @use 'bodyParser', 'methodOverride', @app.router, 'static'
        @enable 'serve zappa'

        @configure
             development: -> 
                @use errorHandler: { dumpExceptions: on, showStack: on }
             production: -> 
                @use 'errorHandler', 'staticCache'


    #routes
        @get '/': ->
            @render 'index'


        @get '/api': ->
            @response.header 'Cache-Control', 'no-cache'
            @response.header 'Expires', 'Fri, 31 Dec 1998 12:00:00 GMT'
            @send 'api'


        @get '/api/search/':->
            @response.header 'Cache-Control', 'no-cache'
            @response.header 'Expires', 'Fri, 31 Dec 1998 12:00:00 GMT'
            @send 'search'


        @get '/api/search/:query': ->
            @response.header 'Cache-Control', 'no-cache'
            @response.header 'Expires', 'Fri, 31 Dec 1998 12:00:00 GMT'
            @params.query
            
            # 1. start crawler & queue items in redis
            
            crawler.search(@params.query)
            # 2. fetch items from redis and return json
            queue.fetchText (err, text) =>
              if err
                  console.log err
                  @send {}
              else
                  @send text: text

             #console.log hyve.queue.text[0]
             #item = hyve.queue.text[0]
            # hyve.dequeue(item);
