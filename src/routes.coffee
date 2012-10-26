#    ROUTES
#########################

module.exports = (app, io, mongoose) ->

    # ## Some static pages 
    app.get '/', (req, res) -> 
      res.render "home"

    app.get '/about', (req, res) ->
      res.render "pages/about"

    # Call for contribution 
    app.get '/join', (req, res) ->
      res.render "pages/join"

    app.get '/docs/:path', (req, res) ->
        console.log req.params
        res.render "public/docs/"+req.params.path, {layout:false}
    
    # Add routes for API
    require('./routes/api') app

    # Add routes for dashboard
    require('./routes/admin') app
   
    # Add routes for demo
    # require('./routes/seurons') app, mongoose, io
    # require('./routes/memes') app
    # require('./routes/messages') app
    # require('./routes/things') app 
    
    # Handle redirect after logout 
    app.get '/logout', (req, res) ->
      req.logout
      res.redirect '/'


    app.get '/weibo', (req, res) ->
      
      if req.session.auth.weibo
        # console.log req.session.auth.weibo
        weiboAPI = require './lib/weiboAPI'
        console.log weiboAPI
        weiboAPI.init req.session.auth.weibo.accessToken, req.session.auth.weibo.user.id

        weiboAPI.getTimeline (data) ->
          res.send data

       






  

