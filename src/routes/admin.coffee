# ## Routes for all admin part

module.exports = (app) ->

    app.get '/admin*', (req, res) ->
        if(!req.session.auth)
            res.render '_login'
        else
            # res.render "../views/admin/dashboard"
            # res.redirect '/admin/memes/all/1'
            include "admin/memes"
            include "admin/seurons"
            include "admin/things"


            