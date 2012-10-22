# queue = require "../lib/redis_queue"

Seuron = require ('../models/Seuron').Seuron

findOrCreateSeuronWithTwitterId = (twitterId, callback) ->
  
  Seuron.findOne {"sns.twitter.id": twitterId}, (err, seuron) ->
    console.log err if err
    if !seuron
      s = new Seuron
      s.sns.twitter.id= twitterId
      s.save (d) ->
        callback(d)
    else
      callback(seuron)


module.exports = {
      findOrCreateSeuronWithTwitterId: findOrCreateSeuronWithTwitterId
    }