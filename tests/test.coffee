request = require("supertest")
app = require("../src/app")
assert = require("assert")

describe "Test home", ->
  it "GET / should return 200", (done) ->
    request(app).get("/").expect 200, done
