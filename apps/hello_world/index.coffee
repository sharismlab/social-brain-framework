zappa = require 'zappajs'

zappa ->
        @configure =>
            @set 'view engine': 'jade', views: "#{__dirname}/views"

        @use 'bodyParser', 'methodOverride', 'static'

    #routes
        @get '/': ->
            @render 'index'

     #backend
        @on submitfield: ->
           console.log "Looking for : ", @data.text
           console.log 'Starting Stream'
           @emit startfeed: {text:@data.text}
           
           snsdata = {"service":"twitter","type":"text","query":"attention","user":{"id":"152426088","avatar":"http://a0.twimg.com/profile_images/2259321960/IMG_20120528_024641-1_normal.jpg","profile":"http://twitter.com/JaneDough___"},"id":"220500706510114816","date":1341406439,"text":"RT @Tankdials15: Lol DamnRT @JaneDough___: Death to all attention seekers.","links":[],"source":"http://twitter.com/JaneDough___/status/220500706510114800","weight":0 }

           @emit snsfeed: {snsdata : snsdata }

    #frontend
        @client '/index.js': ->
          @connect()
          # console.log this

          @on startfeed: ->
             $ =>          
                $('#panel').append '<ul>' + @data.text + '</ul>'
                console.log 'Starting Stream'

          @on snsfeed: ->
             # console.log @data.snsdata
             $ =>
                $('#panel ul').append '<li class="alert alert-error"><strong>' + @data.snsdata.service + '</strong>' + @data.snsdata.text + '</li>'

          $ =>
            $('#box').focus()

            $('button').click (e) =>
              @emit submitfield: {text: $('#box').val()}
              console.log $('#box').val()
              $('#panel').append "<h2> "+ $('#box').val() + "</h2>"
              $('#box').val('').focus()
              e.preventDefault()
