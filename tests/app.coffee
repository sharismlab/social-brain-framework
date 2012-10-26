app = require("../src/app")
assert = require("assert")

#add helpers for http testing 
request = require("supertest")

#enable BDD syntax
chai = require 'chai'  
chai.should()

# Mongoose
mongoose = require 'mongoose'

#tell Mongoose to use a different DB - created on the fly
db = mongoose.createConnection("mongodb://localhost/sb_test")