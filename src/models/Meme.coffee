# Meme model

mongoose = require("mongoose")
troop = require 'mongoose-troop'

collection = "Memes"
    

Schema = mongoose.Schema
ObjectId = mongoose.SchemaTypes.ObjectId

MemeSchema = new Schema
    title: String
    description: String
    messages: Array
    things: Array


MemeSchema.plugin(troop.timestamp)
MemeSchema.plugin(troop.pagination)

Meme = mongoose.model('Meme', MemeSchema)

module.exports = {
  Meme:Meme
}