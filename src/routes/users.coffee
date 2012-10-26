# ## Routes to handle users

# Semantic forms with bootstrap 
forms = require 'forms-bootstrap'

module.exports = (app) ->


    userform = forms.create
        title: forms.fields.string
            required: true
            widget: forms.widgets.text
                placeholder: 'Username'
                classes: ['span6']
        description: forms.fields.string
            widget: forms.widgets.text
                placeholder: 'Add a short description'
                classes: ['span6']

    # User can register only using their social networks accounts

    # People should first login using a sns account
    # GET
    app.get '/register', (req, res) ->
        res.render "register"
    
    # Once registered, they can add a username, some other infos and other sns accounts
    app.get '/users/new', (req, res) ->
        if !req.session.auth
            res.render "register"
        else
            req.session
            res.render "users/new", userform: userform.toHTML(), 

    # POST
    app.post '/users/new', (req, res) ->
        userform.handle req.body,
            success: (form) ->
                console.log "created"
                req.flash 'info','Meme added'
                res.redirect '/admin/memes/'+meme.id
            error: (form) ->
                # handle the error, by re-rendering the form again
                res.render "users/new", userform: {}




    
