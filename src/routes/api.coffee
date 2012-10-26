# ## API for Social Brain Framework.
    
# Now only JSON is supported

module.exports = (app) ->
    
    # Home page 
    app.get '/api', (req, res) ->
        res.header 'Cache-Control', 'no-cache'
        res.header 'Expires', 'Fri, 31 Dec 1998 12:00:00 GMT'
        res.send 'Thanks for using our API ! The docs are <a href="/docs">here</a>.'

    # Search API, yet to be implemented
    app.get '/api/search', (req, res) ->
        res.header 'Cache-Control', 'no-cache'
        res.header 'Expires', 'Fri, 31 Dec 1998 12:00:00 GMT'
        res.send 'Search not implemented yet!'

    # ## Add routes for API

    require('./api/memes') app
    require('./api/messages') app
    require('./api/things') app
    require('./api/seurons') app




