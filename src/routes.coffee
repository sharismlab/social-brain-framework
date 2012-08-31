##    ROUTES
#########################

module.exports = (app, models) ->

    app.get '/auth', (req, res) -> 
      # res.redirect "/auth/twitter" if app.requireAuth is true and req.loggedIn is false

      if (req.session.auth)
        user = req.session.auth.twitter.screen_name
      #get all the rides
      # models.examples.find {}, (err, docs) ->

         #render the index page
      res.render "index",
            layout: false
            locals:
              user:user

    app.get '/ok', (req, resp) -> 
      resp.send 'logged in ok!'

    app.get '/', (req, resp) -> 
      resp.send 200, 'social brain! try the <a href="/api">API</a>'


    app.get '/api', (req, resp) ->
        resp.header 'Cache-Control', 'no-cache'
        resp.header 'Expires', 'Fri, 31 Dec 1998 12:00:00 GMT'
        resp.send 'api'


    app.get '/api/search', (req, resp) ->
        resp.header 'Cache-Control', 'no-cache'
        resp.header 'Expires', 'Fri, 31 Dec 1998 12:00:00 GMT'
        resp.send 'search'
