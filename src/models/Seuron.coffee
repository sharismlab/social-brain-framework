module.exports = (mongoose) ->
  collection = "Seurons"
  
  Schema = mongoose.Schema
  #ObjectId = Schema.ObjectId
  ObjectId = mongoose.SchemaTypes.ObjectId

  seuronSchema = new Schema(
    username: String
    twitterID: Number
    user_id : { 
      type: ObjectId, 
      index : true
      ref: 'UserSchema'
    }
    created_at: Date
    id: ObjectId
  )

  seuronSchema