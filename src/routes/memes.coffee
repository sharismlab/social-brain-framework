module.exports = (app) ->

    # mongoose.set('debug', true)

    # Import Meme model
    Meme = require('../models/Meme').Meme

    # GET a list of all memes
    app.get '/memes', (req, res) ->
        Meme.find({}).sort("sns.twitter.id").execFind (err, memes) ->
            # console.log memes
            res.render '../views/memes/index.jade', { memes: memes }

    # GET a single meme
    app.get '/memes/:id', (req, res) ->
        Meme.findById req.params.id, (err, meme) ->
                # console.log meme

                # Prevent null or errors
                res.send 'Document not found' if !meme 
                res.send err if err

                # Render the template...
                res.render '../views/memes/single.jade', { meme: meme }





