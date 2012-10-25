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

    # Add routes for dashboard
    require('./routes/admin') app
   
    # Add routes for demo
    require('./routes/seurons') app, mongoose, io

    # Routes for memes
    require('./routes/memes') app 
    require('./routes/things') app 

    # Routes for messages

    # Import Message model
    Message = require('./models/Message').Message

    # Message paginated
    app.get '/messages', (req, res) ->
      Message.firstPage (err, docs, count, pages, current) ->
        res.redirect '/messages/1'

    app.get '/messages/:page', (req, res) ->
      Message.paginate { page: req.params.page,limit: 50 },  (err, docs, count, pages, current) ->
        p =[]
        i = 1
        while i < pages
          p.push i
          i++
        
        console.log "pages"+pages
        console.log "p"+p

        res.render 'messages/index', {messages :docs, count:count , pages: p, current:current }

        # res.send {
        #   "docs.length ":docs.length
        #   "count ":count 
        #   "pages":pages
        #   "current":current          
        # }

    app.get '/demo', (req, res) ->
      res.render "demo"
    
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

       






  

