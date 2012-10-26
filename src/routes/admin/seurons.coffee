# ## Seurons model

module.exports = (app) ->
    
    # Import Seuron model  
    Seuron = require('../../models/Seuron').Seuron

    app.get "/admin/myseuron" , (req, res) ->

        if(req.session.auth.twitter)
            Seuron.findOne {"sns.twitter.id" : req.session.auth.twitter.user.id}, (err, seuron) ->
                console.log seuron
                res.send err if err  # Prevent null or errors
                # Render my seuro template...
                res.render 'admin/myseuron', {seuron:seuron}

        else if(req.session.auth.weibo)
            # console.log req.session.auth.weibo.user.id
            Seuron.findOne {"sns.weibo.id" : req.session.auth.weibo.user.id }, (err, seuron) ->
                console.log seuron
                res.send err if err  # Prevent null or errors
                # Render my seuro template...
                res.render 'admin/myseuron', {seuron:seuron}
