# Thread is just a little class to store all messages from a specific thread
# This collection is depreciated
# Instead we just have a var in Message storing the ref

mongoose = require("mongoose")

collection = "Threads"
    

Schema = mongoose.Schema
ObjectId = mongoose.SchemaTypes.ObjectId

ThreadSchema = new Schema
    messages: Array


Thread = mongoose.model('Thread', ThreadSchema)

module.exports = {
  Thread:Thread
}