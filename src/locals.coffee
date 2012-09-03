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

# Fix for broken expressHelpers; https://github.com/bnoguchi/everyauth/issues/303
  preEveryAuthMiddlewareHack: ->
    (req, res, next) ->
      sess = req.session
      auth = sess.auth
      ea =
        loggedIn: auth?.loggedIn

      ea[k] = val for own k, val of auth

      if everyauth.enabled.password
        ea.password = ea.password || {}
        ea.password.loginFormFieldName = everyauth.password.loginFormFieldName()
        ea.password.passwordFormFieldName = everyauth.password.passwordFormFieldName()

      res.locals.everyauth = ea

      do next

  postEveryAuthMiddlewareHack: ->
    userAlias = everyauth.expressHelperUserAlias || "user"
    (req, res, next) ->
      res.locals.everyauth.user = req.user
      res.locals[userAlias] = req.user
      do next