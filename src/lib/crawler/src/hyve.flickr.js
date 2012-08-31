(function(root) {

    var hyve = (typeof require == 'function') ? require('../src/hyve.core.js') : root.hyve

    hyve.feeds['flickr'] = {
        methods : ['search', 'friends'],
        interval : 10000,
        result_type : 'date-posted-desc',  // date-posted-asc, date-posted-desc, date-taken-asc, date-taken-desc, interestingness-desc, interestingness-asc, relevance
        api_key: '',
        auth_token: '',
        api_sig: '',
        url_suffix_auth : 'rest/?method=flickr.photos.search&',
        url_suffix_anon : 'feeds/photos_public.gne?',
        feed_urls : {
            search: 'http://api.flickr.com/services/{{url_suffix}}&per_page=20&format=json{{#&sort=#result_type}}&tagmode=all&tags={{query}}{{#&jsoncallback=#callback}}&content_type=1&extras=date_upload,date_taken,owner_name,geo,tags,views,url_m,url_b{{#&api_key=#api_key}}',
            friends: 'http://api.flickr.com/services/rest/?method=flickr.photos.getContactsPhotos&api_key={{ api_key }}&extras=date_upload%2Cdate_taken%2Cowner_name%2Cgeo%2Ctags%2Cviews%2Curl_m%2Curl_t&format=json&nojsoncallback=1&auth_token={{ auth_token }}&api_sig={{ api_sig }}{{#&jsoncallback=#callback}}'
        },
        format_url : function(query){
            var url_suffix
            if (this.api_key){
                url_suffix = this.url_suffix_auth
            } else {
                url_suffix = this.url_suffix_anon
            }
            return {   query: query
                     , url_suffix: url_suffix
                     , result_type: this.result_type
                     , api_key: this.api_key
                     , auth_token: this.auth_token
                     , api_sig: this.api_sig
            }
        },
        parsers : {

            search: function(data, query, callback){

                var api_key = hyve.feeds.flickr.api_key

                if (!this.items_seen){
                    this.items_seen = {}
                }
                var items
                if (api_key){
                    items = data.photos.photo
                } else {
                    items = data.items
                }
                items && items.forEach(function(item){
                    var id, thumbnail, source_img, userid, username, source
                    if (api_key){
                        id = item.id
                        if (item.url_m){
                            thumbnail = item.url_m
                            source_img = item.url_m.replace('.jpg','_b.jpg')
                        }
                        username = item.ownername
                        userid = item.owner
                    } else {
                        id = item.media.m
                        thumbnail = item.media.m
                        source_img = item.media.m.replace('_m','_b')
                        source = item.media.m.replace('_m','_b')
                        username = item.author
                        userid = item.author_id
                    }
                    var weight = 0
                    if (item.views){
                        weight = item.views
                    }
                    if (!this.items_seen[id]){
                        this.items_seen[id] = true
                        hyve.process({
                            'service' : 'flickr',
                            'type' : 'image',
                            'query' : query,
                            'user' : {
                                'id' : userid,
                                'name' : username,
                                'avatar' : ''
                            },
                            'id' : id,
                            'date' : item.dateupload,
                            'text' : item.title,
                            'source' : item.link,
                            'source_img' : source_img,
                            'thumbnail': thumbnail,
                            'weight' : weight
                        },callback)
                    }
                }, this)
            },

            friends: function(data, query, callback) {
                 if (!this.items_seen){
                    this.items_seen = {}
                }
                var items = data.photos.photo
                items.forEach(function(item) {
                    if (!this.items_seen[item.id]) {
                        this.items_seen[item.id] = true

                        source_url = 'http://flickr.com/photos/'+item.owner+'/'+ item.id
                        source_img = 'http://farm'+ item.farm + '.staticflickr.com/' + item.server + '/' + item.id + '_' + item.secret + '.jpg'

                        hyve.process({
                            'service' : 'flickr',
                            'type' : 'image',
                            'query' : query,
                            'user' : {
                                'id' : item.owner,
                                'name' : item.username,
                                'avatar' : ''
                            },
                            'id' : item.id,
                            'date' : item.dateupload,
                            'text' : item.title,
                            'source' : source_url,
                            'source_img' : source_img,
                            'thumbnail': item.url_t,
                            'weight' : item.views
                        }, callback)
                    }
                }, this)
            }
        }
    }

})(this)
