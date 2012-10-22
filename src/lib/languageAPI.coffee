# ## Language API
# All functions related to language detection and processing

# ## Language detection
# Tested node libraries : 
#
# * guesslanguage - 
# * cld : based on google language - paid version only
# * languagedetect : no chinese 
#
# 

#   res.send language
guessLanguage = require 'guesslanguage'
# console.log guessLanguage


detectLanguage = (text, callback) ->
    guessLanguage.guessLanguage.detect text, (language) ->
        # console.log "language is : "+language
        callback(language)

# export methods
module.exports =
    detectLanguage : detectLanguage