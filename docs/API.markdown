# API


    /api
return nothing


## search social web

    /api/search/:query

crawl social networks stream for "query" term

#### query parameters :

* "sns" : select web services you want to crawl using  :

    example : /api/search/sharism?sns=tw,fb
    * tw = twitter
    * fb = facebook
    * wb = weibo (not implemented yet) 
    * wp = wordpress
    * yt = youtube
