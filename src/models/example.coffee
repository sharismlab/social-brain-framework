module.exports = (mongoose) ->
  collection = "examples"
  Schema = mongoose.Schema
  ObjectId = Schema.ObjectId
  schema = new Schema(
    author: ObjectId
    name: String
    date: Date
  )
  @model = mongoose.model(collection, schema)
  this
