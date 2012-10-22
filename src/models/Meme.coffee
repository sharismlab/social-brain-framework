# Meme model

mongoose = require("mongoose")
troop = require 'mongoose-troop'

collection = "Memes"
    

Schema = mongoose.Schema
ObjectId = mongoose.SchemaTypes.ObjectId

MemeSchema = new Schema
    messages: Array

MemeSchema.plugin(troop.timestamp)

Meme = mongoose.model('Meme', MemeSchema)

module.exports = {
  Meme:Meme
}