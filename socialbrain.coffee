zappa = require 'zappajs'
apikeys = require('./config/apikeys')
dbinfo =  require('./config/db')
mongoose = require 'mongoose'
db = mongoose.connect('mongodb://localhost/socialbrain')

# chose here which app you want to work with
myapp = "hello_world"


#crawler setup 
hyve = require('./connectors/src/hyve.core.js')
require('./connectors/src/hyve.twitter.js')
require('./connectors/src/hyve.facebook.js')

hyve.queue_enable = false
hyve.recall_enable = false


# let's go!
zappa ->

        @configure =>
            @set 'view engine': 'jade', views: "#{__dirname}/apps/#{myapp}/views"

        #@use require('connect-assets')()
        @use 'bodyParser', 'methodOverride', 'static': "#{__dirname}/apps/#{myapp}/public"

        @enable 'serve jquery'

        @configure
             development: -> 
                @use errorHandler: { dumpExceptions: on, showStack: on }
             production: -> 
                @use 'errorHandler', 'staticCache'


    #routes
        @get '/': ->
            @render 'index', foo: 'bar'
            
        @get '/api': ->
            @response.header 'Cache-Control', 'no-cache'
            @response.header 'Expires', 'Fri, 31 Dec 1998 12:00:00 GMT'
            'api!'

