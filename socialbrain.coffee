zappa = require 'zappajs'
apikeys = require('./config/apikeys')
config =  require './config/db'
r = require 'redis'
m = 'exports'

#import crawler
crawler = require './lib/crawler/crawler'
queue = require './lib/crawler/queue'

# console.log(crawler)

# let's go!
zappa 'localhost', 3000, ->

        @use 'bodyParser', 'methodOverride', @app.router, 'static'
        @enable 'serve zappa'

        @configure
             development: -> 
                @use errorHandler: { dumpExceptions: on , showStack: on }
             production: -> 
                @use 'errorHandler', 'staticCache'


    #routes
        @get '/': ->
            @send 'social brain! try the <a href="/api">API</a>'


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
            # console.log @params
            # console.log @query

            if !@query.sns  
               @send 'ERROR : you should specify web services names in your query'

            #fetch sns names and convert to proper array
            sns = []
            fullSnsName = (sn) ->
              switch sn
                when "tw" then return "twitter"
                when "fb" then return "facebook"
                when "fs" then return "foursquare"
                when "wb" then return "weibo"
                when "wp" then return "wordpress"
                when "yt" then return "youtube"
                else return null
            query = @query.sns.split ","
            sns.push fullSnsName(sn) for sn in query

            # 1. start crawler & queue items in redis
            searchID = crawler.search(@params.query, sns)
            # console.log "search id : " + searchID

            # 2. return crawler job info in json
            queue.fetchMessage searchID , (err, data) =>
                if err
                        console.log err
                        @send {}
                    else
                        @send
                            createdAt:   new Date
                            id:    searchID
                            queryType:  "search"
                            query:      @params.query
                            sns:        sns
                            # type:       data.type



         #more useless attempts behind there -----------------------------------

         @get '/snsnames/' : ->
           # url using abbreviation ?sns=tw,fb



           @send {sns}
