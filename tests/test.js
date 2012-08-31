var request = require('supertest'),
	app = require('../src/app'),
	assert = require("assert");

describe('User API', function() {
  it('GET / should return 200', function(done) {
    request(app)
    	.get('/')
    	.expect('200', done);
  })
})