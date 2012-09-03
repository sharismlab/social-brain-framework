module.exports = (mongoose) ->
  collection = "users"
  
  Schema = mongoose.Schema
  #ObjectId = Schema.ObjectId
  ObjectId = mongoose.SchemaTypes.ObjectId

  UserSchema = new Schema(
    author: ObjectId
    name: String
    date: Date
  )

  this