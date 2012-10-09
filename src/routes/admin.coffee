# ## Routes for all admin part & dashboard

module.exports = (app) ->

    app.get '/admin', (req, res) ->
          res.render "../views/admin/dashboard"