express = require 'express'
helpers = require "./locals"
http = require 'http'
mongoose = require 'mongoose'

app = express()

#create web socket
server = http.createServer(app)

#add my helpers
app.locals helpers.locals

# all config for app
config = require('./config') app, express, mongoose

# Define Port
port = process.env.PORT or process.env.VMC_APP_PORT or 3000

# Start Server
server.listen port, -> 
    console.log "#{app.locals.appName} v.#{app.locals.version} running on #{port}\nPress CTRL-C to stop server."

#socket
io = require('socket.io').listen(server)

##    ROUTES
#########################

require('./routes') app, io, mongoose

#exports app for tests
module.exports = app;
