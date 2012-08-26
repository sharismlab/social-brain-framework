zappa = require 'zappajs'
#apikeys = require('./config/apikeys')

redis = require 'redis'
config =  require '../config/db'

#import crawler
crawler = require '../lib/crawler/crawler'
queue = require '../lib/crawler/queue'

# console.log(crawler)

# let's go!
zappa 3003, ->

        @use 'bodyParser', 'methodOverride', @app.router, 'static'
        @set 'view engine': 'eco', views: "#{__dirname}/examples"
        @enable 'serve zappa'

        @configure
             development: -> 
                @use errorHandler: { dumpExceptions: on , showStack: on }
             production: -> 
                @use 'errorHandler', 'staticCache'

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

        @helper fullSnsName: (sn) ->
              switch sn
                when "tw" then return "twitter"
                when "fb" then return "facebook"
                when "fs" then return "foursquare"
                when "wb" then return "weibo"
                when "wp" then return "wordpress"
                when "yt" then return "youtube"
                else return null

        @get '/api/search/:query': ->

            @response.header 'Cache-Control', 'no-cache'
            @response.header 'Expires', 'Fri, 31 Dec 1998 12:00:00 GMT'

            if !@query.sns  
               @send 'ERROR : you should specify web services names in your query'

            #fetch sns names from URL and convert names
            sns = []
            query = @query.sns.split ","
            sns.push @fullSnsName(sn) for sn in query

            #start crawler & queue items in redis store
            searchKey = crawler.search(@params.query, sns)

            #return crawler job info in json
            queue.fetchInfo searchKey , (err, data) =>
                if err
                        #console.log err
                        @send {}
                else
                        # console.log data
                        @send
                            createdAt:   new Date
                            id:         searchKey
                            queryType:  "search"
                            query:      @params.query
                            sns:        sns


         #more useless attempts behind there -----------------------------------
        @get '/snsnames' : ->
           # url using abbreviation ?sns=tw,fb
           @send {sns}
