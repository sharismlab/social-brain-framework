###
Interaction class

    Actions are defined by the following int
            0 :     unknown
            1 :     post // rien !
            2 :     RT // green #00FF85
            3 :     answer // orange #ff9000
            4 :     @at // rose #ee64ff
###

mongoose = require("mongoose")
troop = require 'mongoose-troop'

collection = "Interactions"

Schema = mongoose.Schema
ObjectId = mongoose.SchemaTypes.ObjectId

InteractionSchema = new Schema
    action:Number
    synapse: 
        type: ObjectId
        index : true
        ref: 'SynapseSchema'

InteractionSchema.plugin(troop.timestamp)

Interaction = mongoose.model('Interaction', InteractionSchema)

module.exports = {
  Interaction:Interaction
}