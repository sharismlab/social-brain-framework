require "./app"


# Add routes 
require "./routes/seurons" db
require "./routes/users" db


# Routes
describe "Test home", ->
  it "GET / should return 200", (done) ->
    request(app).get("/").expect 200, done
