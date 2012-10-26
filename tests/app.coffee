app = require "../src/app"
assert = require "assert"

#add helpers for http testing 
request = require "supertest"

#enable BDD syntax
chai = require 'chai'  
chai.should()

# Mongoose
mongoose = require 'mongoose'

#tell Mongoose to use a different DB - created on the fly
db = mongoose.createConnection "mongodb://localhost/sb_test"

# require "./assets"

# # MODELS
require("./models/User") db, app
# require("./models/Seuron") db

# # ROUTES 
describe "Static routes", ()->

    it "GET / should return 200", (done) ->
        request(app).get("/").expect 200, done

    it "GET /about should return 200", (done) ->
        request(app).get("/about").expect 200, done


require("./routes/users") db
# require("./routes/seurons") db
# require("./routes/api") db

# # LIBS
require("./lib/semantic") db
