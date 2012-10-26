# ## Routes for all messages

module.exports = (app) ->

    # Import Message model
    Message = require('./models/Message').Message

    # Message paginated
    app.get '/messages', (req, res) ->
      Message.firstPage (err, docs, count, pages, current) ->
        res.redirect '/messages/1'

    app.get '/messages/:page', (req, res) ->
      Message.paginate { page: req.params.page,limit: 50 },  (err, docs, count, pages, current) ->
        p =[]
        i = 1
        while i < pages
          p.push i
          i++
        
        console.log "pages"+pages
        console.log "p"+p

        res.render 'messages/index', {messages :docs, count:count , pages: p, current:current }

        # res.send {
        #   "docs.length ":docs.length
        #   "count ":count 
        #   "pages":pages
        #   "current":current          
        # }

