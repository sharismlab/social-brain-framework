module.exports = (app) ->

    # mongoose.set('debug', true)

    # Import Meme model
    Meme = require('../models/Meme').Meme

    # GET a list of all memes
    app.get '/memes', (req, res) ->

        Meme.find({}).sort("sns.twitter.id").execFind (err, memes) ->
            # console.log memes
            res.render '../views/memes/index.jade', { memes: memes }

    # create a new meme
    app.get '/memes/new', (req, res) ->
        # Render the template...
        res.render '../views/memes/new.jade'

    # GET a single meme
    app.get '/memes/:id', (req, res) ->
        Meme.findById req.params.id, (err, meme) ->
                # console.log meme

                # Prevent null or errors
                res.send 'Document not found' if !meme 
                res.send err if err

                # Render the template...
                res.render '../views/memes/single.jade', { meme: meme }



    # edit a meme
    app.get '/memes/edit/:id', (req, res) ->
        # Edit a record
        Post.findById req.params.id, (err, meme) ->
            console.log err if err
            res.render 'edit.jade', { meme : meme }
            console.log "Editing " + post.id




