###
Synapse class is intended to store relationships between seurons.

    It contains an object with 3 values : Seuron A, Seuron B, int level, int weight
        ex : Synapse( A, B, 1 )

    Level : is a int that decribes the level of relationship between 2 seurons

        Unknown:            0
        Friend & Follow:    1 
        is Friend of:       2 
        is Followed by:     3
        No relationships:   4

    Synapses are directionals
        
        Synapse(A, B, 3) means that A is followed by B, i.e. B follows A
        Synapse(B, A, 3) means the opposite, i.e. A follows B

    Weight : represents the quantity of activity between 2 seurons. 
            Every time there is an interactions, it is increased 
            example : RT +1
### 

mongoose = require("mongoose")

collection = "synapses"

Schema = mongoose.Schema
ObjectId = mongoose.SchemaTypes.ObjectId

SynapseSchema = new Schema
    seuronA :
      __id :
        type: ObjectId
        index: true
        ref: 'SeuronSchema' 
      twitterId : Number
    seuronB : 
      __id :
        type: ObjectId
        index: true
        ref: 'SeuronSchema' 
      twitterId : Number
    level: Number 
    service: String 


Synapse = mongoose.model('Synapse', SynapseSchema)

module.exports = {
  Synapse:Synapse
}