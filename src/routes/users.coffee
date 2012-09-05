module.exports = (app) ->

  app.get '/logout', (req, res) ->
      req.logout
      res.redirect '/'

  app.get '/termsofuse', (req, res) ->
     res.render "termsofuse"
     