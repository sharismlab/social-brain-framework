# ## Routes for all admin part

module.exports = (app) ->

    app.all '/admin*', (req, res, next) ->
        if(!req.session.auth)
            res.render '_login'
        else
            do next
            # res.render "../views/admin/dashboard"

    app.get '/admin/', (req, res) ->
        res.redirect '/admin/myseuron'


    require("./admin/memes") app
    require("./admin/seurons") app
    require("./admin/things") app


            