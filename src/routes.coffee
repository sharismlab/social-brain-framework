#    ROUTES
#########################

module.exports = (app, io, mongoose) ->

    # Some static pages 
    app.get '/', (req, res) -> 
      res.render "index"

    app.get '/about', (req, res) ->
      res.render "about"

    # Call for contribution 
    app.get '/join', (req, res) ->
      res.render "join"
    
    # Page to store some info about current research
    app.get '/socialbrain', (req, res) ->
      res.render "socialbrain"

    app.get '/docs/:path', (req, res) ->
        console.log req.params
        res.render "public/docs/"+req.params.path, {layout:false}


    
    # Add routes for API
    require('./routes/api') app
   
    # Add routes for demo
    require('./routes/seurons') app, mongoose, io

    app.get '/demo', (req, res) ->
      res.render "demo"
    

    # Handle redirect after logout 
    app.get '/logout', (req, res) ->
      req.logout
      res.redirect '/'