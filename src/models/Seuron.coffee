module.exports = (mongoose, ntwi) ->
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

  seuronSchema.methods.fetchTwitterTimeline = ->
    #Add a method to fetch timeline from Twitter using twitterID
    console.log "fetch timelien"




  seuronSchema