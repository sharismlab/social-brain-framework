# ## Routes for all admin part & dashboard

module.exports = (app) ->

    app.get '/admin', (req, res) ->
        # res.render "../views/admin/dashboard"
        res.redirect '/admin/memes/1'

        


    # ##Memes routes

    # Import Meme model
    Meme = require('../models/Meme').Meme

    # Semantic forms with bootstrap 
    forms = require 'forms-bootstrap'

    memeform = forms.create
        title: forms.fields.string
            required: true
            widget: forms.widgets.text
                placeholder: 'Title'
                classes: ['span5']


    # New
    app.get '/admin/memes/new', (req, res) ->
        res.render "../views/admin/memes/new", memeform: memeform.toHTML()

    
    # Create
    app.post '/admin/memes/new', (req, res) ->
        console.log "post meme : " 
        console.log req.body
        memeform.handle req.body,
            success: (form) ->
                meme = new Meme({
                    title : req.body.title
                    })
                meme.content = req.body.content
                meme.save (err) ->
                    console.log err if err
                    console.log "created"
                    req.flash 'info','Meme added'
                    res.redirect '/admin/memes/edit/'+meme.id
            error: (form) ->
                # handle the error, by re-rendering the form again
                res.render '../views/admin/memes/new', memeform: memeform.toHTML()

    # Edit a record
    app.get '/admin/memes/edit/:id', (req, res) ->
        Meme.findById req.params.id, (err, meme) ->
            console.log err if err
            res.render '../views/admin/memes/edit.jade', { meme : meme, memeform: memeform.bind(meme).toHTML()  }
            console.log "Editing " + meme.id

    # Update
    app.put '/memes/edit/:id', (req, res) ->
        Post.findById req.params.id, (err, meme) ->
            console.log err if err
            console.log "Update " + post.id + req.body
            meme.title = req.body.title
            meme.save (err) ->
                console.log err if err
                console.log err "Meme updated!"
                req.flash 'info','Meme updated'
                res.send meme { message : 'Success!'}

    # Index (paginated)
    app.get '/admin/memes/:page', (req, res) ->
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