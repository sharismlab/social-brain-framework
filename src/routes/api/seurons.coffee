# ## Seurons API

# Import Seuron model
Seuron = require('../models/Seuron').Seuron

module.exports = (app) ->

    # Create
    # POST 
    # example http://website/api/seurons/new?options
    app.post '/api/seurons/new', (req, res) ->
        console.log "POST : "
        seuron = new Seuron()
        seuron.save (err, seuron) ->
            res.json err if err
            console.log "created"
            req.json seuron

    # Read/Edit a record
    # GET
    # example http://website/api/seurons/1646798731679
    app.get '/api/seurons/:id', (req, res) ->
        Seuron.findById req.params.id, (err, seuron) ->
            console.log err if err
            res.json seuron

    # Update
    # PUT
    # example http://website/api/seurons/1646798731679/?options
    app.put '/api/seurons/:id', (req, res) ->
        seuron.findById req.params.id, (err, seuron) ->
            seuron.description = req.params.description
            seuron.seuron = req.params.seuron
            seuron.save (err) ->
                res.json err if err
                res.json seuron : seuron


    # Index (paginated)
    # GET
    # example : http://website/api/seurons/all/pages/1
    app.get '/api/seurons/all/page/1', (req, res) ->
      Seuron.paginate { page: req.params.page,limit: 50 },  (err, docs, count, pages, current) ->
        data =
            seurons :docs
            count: count
            total_pages: p
            current_page: current 

        res.json data

    # DELETE a record
    # GET
    # example : http://website/api/seurons/0136745154646/delete
    app.get '/api/seurons/delete/:id', (req,res) ->
        Seuron.findById req.params.id, (err,seuron) ->
            res.json err if err 
            seuron.remove()
            res.json 'seuron Deleted'