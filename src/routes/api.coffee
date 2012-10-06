module.exports = (app) ->
    
    app.get '/api', (req, res) ->
        res.header 'Cache-Control', 'no-cache'
        res.header 'Expires', 'Fri, 31 Dec 1998 12:00:00 GMT'
        res.send 'The api is currently under development, please stay tuned'

    app.get '/api/search', (req, res) ->
        res.header 'Cache-Control', 'no-cache'
        res.header 'Expires', 'Fri, 31 Dec 1998 12:00:00 GMT'
        res.send 'search'