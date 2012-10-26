# ##Memes routes

module.exports = (app) ->

    # Import Meme model
    Meme = require('../models/Meme').Meme

    # Semantic forms with bootstrap 
    forms = require 'forms-bootstrap'

    memeform = forms.create
        title: forms.fields.string
            required: true
            widget: forms.widgets.text
                placeholder: 'Meme Title'
                classes: ['span6']
        description: forms.fields.string
            widget: forms.widgets.text
                placeholder: 'Add a description'
                classes: ['span6']

    # New
    app.get '/admin/memes/new', (req, res) ->
        res.render "../views/admin/memes/new", memeform: memeform.toHTML()

    # Create
    app.post '/admin/memes/new', (req, res) ->
        console.log "POST : " 
        console.log req.body
        memeform.handle req.body,
            success: (form) ->
                meme = new Meme({
                    title : req.body.title
                    description : req.body.description
                    })
                # meme.content = req.body.content
                meme.save (err) ->
                    console.log err if err
                    console.log "created"
                    req.flash 'info','Meme added'
                    res.redirect '/admin/memes/'+meme.id
            error: (form) ->
                # handle the error, by re-rendering the form again
                res.render '../views/admin/memes/new', memeform: memeform.toHTML()

    # Read/Edit a record
    app.get '/admin/memes/:id', (req, res) ->
        Meme.findById req.params.id, (err, meme) ->
            console.log err if err
            res.render '../views/admin/memes/new.jade', { meme : meme, memeform: memeform.bind(meme).toHTML()  }

    # Update
    app.post '/admin/memes/:id', (req, res) ->
        Meme.findById req.params.id, (err, meme) ->
            console.log err if err
            console.log "UPDATE " 
            console.log req.body
            meme.title = req.body.title
            meme.description = req.body.description
            meme.save (err) ->
                console.log err if err
                console.log "Meme updated!"
                req.flash 'info','Meme updated'
                res.render '../views/admin/memes/new.jade', { meme : meme, memeform: memeform.bind(meme).toHTML(), message: "Edited successfully"  }

    # Index (paginated)
    app.get '/admin/memes/all/:page', (req, res) ->
      Meme.paginate { page: req.params.page,limit: 50 },  (err, docs, count, pages, current) ->
        p =[]
        i = 1

        while i < pages
          p.push i
          i++

        res.render 'admin/memes/index', {memes :docs, count:count , pages: p, current:current }

    # Delete a record
    app.get '/admin/memes/delete/:id', (req,res) ->
        Meme.findById req.params.id, (err,meme) ->
            console.log err if err 
            meme.remove()
            req.flash 'info','Deleted'
            res.redirect '/admin'

    ## Sources
    app.get '/admin/source/:name', (req,res) ->
        res.render "admin/source", {service: req.params.name}