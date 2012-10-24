# URL model

mongoose = require("mongoose")
troop = require 'mongoose-troop'

collection = "URLs"
    

Schema = mongoose.Schema
ObjectId = mongoose.SchemaTypes.ObjectId

URLSchema = new Schema
    url: String
    description: String

URLSchema.plugin(troop.timestamp)
URLSchema.plugin(troop.pagination)

URL = mongoose.model('URL', URLSchema)

module.exports = {
  URL:URL
}