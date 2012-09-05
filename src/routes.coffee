##    ROUTES
#########################

module.exports = (app, models) ->


    require('./routes/users') app


    app.get '/', (req, res) -> 
      res.render "index"

    app.get '/about', (req, res) ->
      res.render "about"

    app.get '/seuron', (req, res) ->
      res.render "seuron", { userdata: app.everyauth }

    app.get '/api', (req, res) ->
        res.header 'Cache-Control', 'no-cache'
        res.header 'Expires', 'Fri, 31 Dec 1998 12:00:00 GMT'
        res.send 'api'

    app.get '/api/search', (req, res) ->
        res.header 'Cache-Control', 'no-cache'
        res.header 'Expires', 'Fri, 31 Dec 1998 12:00:00 GMT'
        res.send 'search'

