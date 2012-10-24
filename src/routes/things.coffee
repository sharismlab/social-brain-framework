# ## Routes for all things

module.exports = (app) ->

    # ##urls routes

    # Import URL model
    URL = require('../models/Things/URL').URL

    # Semantic forms with bootstrap 
    forms = require 'forms-bootstrap'

    URLform = forms.create
        url: forms.fields.url
            required: true
            widget: forms.widgets.text
                placeholder: 'url'
                classes: ['span6']
        description: forms.fields.string
            widget: forms.widgets.text
                placeholder: 'Add a description'
                classes: ['span6']

    # New
    app.get '/admin/things/urls/new', (req, res) ->
        res.render "../views/admin/things/urls/new", URLform: URLform.toHTML()

    # Create
    app.post '/admin/things/urls/new', (req, res) ->
        console.log "POST : " 
        console.log req.body
        URLform.handle req.body,
            success: (form) ->
                url = new URL({
                    url : req.body.url
                    description : req.body.description
                    })
                # URL.content = req.body.content
                url.save (err) ->
                    console.log err if err
                    console.log "created"
                    req.flash 'info','URL added'
                    res.render '../views/admin/things/urls/new', {URLform: "Created !"}
            error: (form) ->
                # handle the error, by re-rendering the form again
                res.render '../views/admin/things/urls/new', URLform: URLform.toHTML()

    # Read/Edit a record
    app.get '/admin/things/urls/:id', (req, res) ->
        URL.findById req.params.id, (err, url) ->
            console.log err if err
            res.render '../views/admin/things/urls/new.jade', { url : url, URLform: URLform.bind(url).toHTML()  }

    # Update
    app.post '/admin/things/urls/:id', (req, res) ->
        URL.findById req.params.id, (err, meme) ->
            url.description = req.body.description
            url.url = req.body.url
            url.save (err) ->
                console.log err if err
                console.log "URL updated!"
                req.flash 'info','URL updated'
                res.send '../views/admin/things/urls/new.jade', { url : url, URLform: URLform.bind(url).toHTML(), message: "Edited successfully"  }

    # Index (formated & paginated)
    app.get '/admin/things/urls/all/:page', (req, res) ->
      URL.paginate { page: req.params.page,limit: 50 },  (err, docs, count, pages, current) ->
        p =[]
        i = 1

        while i < pages
          p.push i
          i++

        res.render 'admin/things/urls/index', {urls :docs, count:count , pages: p, current:current }

    # List (raw table)
    app.get '/admin/things/urls/list/:page', (req, res) ->
      URL.paginate { page: req.params.page,limit: 50 },  (err, docs, count, pages, current) ->
        p =[]
        i = 1

        while i < pages
          p.push i
          i++

        res.render 'admin/things/urls/list', {urls :docs, count:count , pages: p, current:current }

    # Delete a record
    app.get '/admin/things/urls/delete/:id', (req,res) ->
        URL.findById req.params.id, (err,url) ->
            console.log err if err 
            url.remove()
            req.flash 'info','Deleted'
            res.redirect '/admin/things/urls/all/1'


    # ## Interaction with meme
    
    # Import Meme model
    Meme = require('../models/Meme').Meme

    # add thing to meme
    app.get '/admin/memes/:memeId/:thing/:thingId', (req,res) ->
        Meme.findById req.params.memeId, (err, meme) ->
            console.log err if err
            thingExists = false
            for thing in meme.things
                thingExists = true if thing.class ==  req.params.thing && thing.id == req.params.thingId 
            if thingExists != true
                thing = {}
                thing.class =  req.params.thing
                thing.id = req.params.thingId 
                meme.things.push(thing)
                meme.save (err) ->
                    console.log err if err
                    res.send "thing added";
            else
                res.send "thing already added"

    app.get '/admin/memes/:memeId/things', (req,res) ->
        Meme.findById req.params.memeId, (err, meme) ->
            console.log err if err
            res.render '../views/admin/memes/_things', {meme:meme}

    app.get '/admin/memes/:memeId/:thing/:thingId/remove', (req,res) ->
        Meme.findById req.params.memeId, (err, meme) ->
            i =0
            while i < meme.things.length
                console.log meme.things[i].class
                if meme.things[i].class ==  req.params.thing && meme.things[i].id == req.params.thingId 
                    console.log 'ok'
                    meme.things.splice(i, 1)
                    res.send "thing was removed from meme"
                i++ 






