

describe "Storages", ->
	describe "mongoose", ->
		it "should have a mongoose store", (done) ->
			request( app ).get("/").expect 200, done