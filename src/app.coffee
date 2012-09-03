express = require 'express'
helpers = require "./locals"
http = require 'http'

#redis clients
# redis = require 'redis'

app = express()

#import crawler
crawler = require './lib/crawler/crawler'
queue = require './lib/storer/redis_queue'
# auth = require './lib/crawler/auth'

#create web socket
server = http.createServer(app)
io = require('socket.io').listen(server)

#add my helpers
app.locals helpers.locals

# all config for app
config = require('./config')( app, express)

# Define Port
port = process.env.PORT or process.env.VMC_APP_PORT or 3000

# Start Server
app.listen port, -> console.log "#{app.locals.appName} v.#{app.locals.version} running on #{port}\nPress CTRL-C to stop server."

#socket
io.sockets.on 'connection', (socket) ->
    console.log 'A socket connected!'

##    ROUTES
#########################

require('./routes') app

app.get '/api/search/:query', (req, resp) ->
    resp.header 'Cache-Control', 'no-cache'
    resp.header 'Expires', 'Fri, 31 Dec 1998 12:00:00 GMT'

    if !req.query.sns
       resp.send 'ERROR : you should specify web services names in your query'

    #fetch sns names from URL and convert names
    sns = []
    query = req.query.sns.split ","
    sns.push app.locals.fullSnsName( sn ) for sn in query

    #start crawler
    searchKey = crawler.search(req.params.query, sns)
    console.log searchKey

    #store in redis
    if req.query.save
      console.log 'saved!'

    resp.send
        createdAt:   new Date
        id:         searchKey
        queryType:  "search"
        query:      req.params.query
        sns:        sns
        storage:    if req.query.save then 'redis' else "no"


#exports app for tests
module.exports = app;
