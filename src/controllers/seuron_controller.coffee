#seuron_controller
mongoose = require 'mongoose'

#Import seuron model
SeuronSchema = require('../models/Seuron') mongoose
mongoose.model('Seuron', SeuronSchema)
Seuron = mongoose.model('Seuron');

Seuron.exports = (mongoose) 