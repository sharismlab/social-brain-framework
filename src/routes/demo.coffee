module.exports = (app) ->

    app.get '/demo', (req, res) ->
      res.render "demo"
    
    app.get '/socialbrain', (req, res) ->
      res.render "socialbrain"