# ## Memes API routes and methods

module.exports = (app) ->

    # Import Meme model
    Meme = require('../../models/Meme').Meme

    # Create
    # POST
    # example : http://website/api/memes/new/?title="my title"&description="blabla"
    app.post '/api/memes/new/', (req, res) ->
        console.log req.params.
        meme = new Meme({
            title : req.body.title
            description : req.body.description
            })
        meme.save (err) ->
            res.json err if err
            res.json meme

    # Read a record
    # GET
    # example : http://website/api/memes/new/?title="my title"&description="blabla"
    app.get '/api/memes/:id', (req, res) ->
        Meme.findById req.params.id, (err, meme) ->
            console.log err if err
            res.json meme

    # Update
    # POST
    # example : http://website/api/memes/0136745154646/?title="my title"&description="blabla"
    app.put '/api/memes/:id/', (req, res) ->
        Meme.findById req.params.id, (err, meme) ->
            meme.title = req.body.title
            meme.description = req.body.description
            meme.save (err) ->
                console.log err if err
                console.log "Meme updated!"
                req.flash 'info','Meme updated'
                res.render '../views/api/memes/new.jade', { meme : meme, memeform: memeform.bind(meme).toHTML(), message: "Edited successfully"  }

    # DELETE a record
    # GET
    # example : http://website/api/memes/0136745154646/delete
    app.get '/api/memes/delete/:id', (req,res) ->
        Meme.findById req.params.id, (err,meme) ->
            res.json err if err 
            meme.remove()
            res.json 'URL Deleted'

    # Index (paginated)
    # GET
    # example : http://website/api/memes/all/pages/1
    app.get '/api/memes/all/:page', (req, res) ->
      Meme.paginate { page: req.params.page,limit: 50 },  (err, docs, count, pages, current) ->

        data =
            memes :docs
            count: count
            total_pages: p
            current_page: current 

        res.json data