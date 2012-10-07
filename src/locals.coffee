###
Helpers for SBF 
###

exports.locals = 
  appName: "Social Brain Framework"
  version: "0.1"
  nameAndVersion: (name, version) ->
    appName + " v" + version
  fullSnsName: (sn) ->
      switch sn
        when "tw" then return "twitter"
        when "fb" then return "facebook"
        when "fs" then return "foursquare"
        when "wb" then return "weibo"
        when "wp" then return "wordpress"
        when "yt" then return "youtube"
        else return null