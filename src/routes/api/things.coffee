# ## API Routes for all things

module.exports = (app) ->

    # ##urls routes

    # Import URL model
    URL = require('../../models/Things/URL').URL

    # Create
    # POST 
    # example http://website/api/things/urls/new?url="http://twitter.com"&description="blabla"
    app.post '/api/things/urls/new', (req, res) ->
        console.log "POST : "
        url = new URL({
            url : req.params.url
            description : req.params.description
            })
        url.save (err, url) ->
            res.json err if err
            console.log "created"
            req.json url


    # Read/Edit a record
    # GET
    # example http://website/api/things/urls/1646798731679
    app.get '/api/things/urls/:id', (req, res) ->
        URL.findById req.params.id, (err, url) ->
            console.log err if err
            res.json url

    # Update
    # PUT
    # example http://website/api/things/urls/1646798731679/?url="http://twitter.com"&description="blabla"
    app.put '/api/things/urls/:id', (req, res) ->
        URL.findById req.params.id, (err, meme) ->
            url.description = req.params.description
            url.url = req.params.url
            url.save (err) ->
                res.json err if err
                res.json url : url

    # Index (Paginated)
    # GET
    # example http://website/api/things/urls/all/page/1
    app.get '/api/things/urls/all/:page', (req, res) ->
      URL.paginate { page: req.params.page,limit: 50 },  (err, docs, count, pages, current) ->
        data =
            urls :docs
            count: count
            total_pages: p
            current_page: current 

        res.json data

    # Delete a record
    # GET
    # example : http://website/api/things/urls/delete/1646798731679
    app.get '/api/things/urls/delete/:id', (req,res) ->
        URL.findById req.params.id, (err,url) ->
            res.json err if err 
            url.remove()
            res.json 'info','Deleted'
            


    # ## Interaction with meme
    
    # Import Meme model
    Meme = require('../../models/Meme').Meme

    # Connect an existing thing to an existing meme
    # GET
    # Return "exist already!" if duplicate
    # http://website/api/things/urls/delete/1646798731679
    app.get '/api/memes/:memeId/:thing/:thingId', (req,res) ->
        Meme.findById req.params.memeId, (err, meme) ->
            res.json err if err
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
                    res.json meme
            else

                res.json { status: "Thing already added to meme!" } 

    # Display all things for a given meme
    # GET
    # Example : http://website/api/things/memes/1646798731679/things
    app.get '/api/memes/:memeId/things', (req,res) ->
        Meme.findById req.params.memeId, (err, meme) ->
            res.json err if err
            res.json res.json meme.things

    # Remove a thing from a meme
    # GET
    # Example : http://website/api/memes/1313467987412/urls/1646798731679/remove
    app.get '/api/memes/:memeId/:thing/:thingId/remove', (req,res) ->
        Meme.findById req.params.memeId, (err, meme) ->
            i =0
            while i < meme.things.length
                console.log meme.things[i].class
                if meme.things[i].class ==  req.params.thing && meme.things[i].id == req.params.thingId 
                    console.log 'ok'
                    console.log meme.things.splice(i, 1)
                    res.send "thing was removed from meme"
                i++ 






