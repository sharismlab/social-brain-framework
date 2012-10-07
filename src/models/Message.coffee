mongoose = require("mongoose")

collection = "messages"

Schema = mongoose.Schema
ObjectId = mongoose.SchemaTypes.ObjectId

MessageSchema = new Schema
    created_at: Date
    updated_at: Date
    id: Number
    service: String
    data: Object
    interactions: Array
    hashtags: Array
    links: Array

MessageSchema.methods.splitDataFromTwitter = (data) ->

    if data.entities.hashtags.length > 0
      i = 0

      while data.entities.hashtags[i]
        @hashtags.push data.entities.hashtags[i]
        i++
    
    if data.entities.urls.length > 0
      i = 0

      while data.entities.urls[i]
        @links.push data.entities.urls[i]
        i++

Message = mongoose.model('Message', MessageSchema)

module.exports = {
  Message:Message
}