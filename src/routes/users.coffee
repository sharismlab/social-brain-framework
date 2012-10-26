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
    app.get '/register', (req, res) ->

        res.render "users/new", userform: {}
    
    # Once registered, they can add a username, some other infos and other sns accounts
    app.get '/users/new', (req, res) ->

        res.render "users/new", userform: userform.toHTML()

    app.get '/users/new', (req, res) ->

        res.render





    
