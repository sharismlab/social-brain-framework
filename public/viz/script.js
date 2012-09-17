var loading = null;
var viz, daddy;
var timeline, followers, friends, mentions;
var userdata = null;
var loaded = false;

var toLookup = [];
var lookupNow = false;

var displaySeuron = false;
var daddyDisplay = false;

// hacky way to check if processing sketch is loaded
// from http://stackoverflow.com/questions/10281747/how-to-know-when-a-processingjs-sketch-has-been-loaded

var timer = 0;
var timeout = 3000;
var mem = setInterval(function () {

        var sketch = Processing.getInstanceById("seuron");
        if (sketch) {
            
            clearInterval(mem);

            console.log("SKETCH HAS LOADED");
            
            loaded = true;
            
            // declare the canvas globally
            viz = sketch;

            // start viz if user is logged in
            if( userdata != null ) startIt();

        } else {

            timer += 10;
            if (timer > timeout) {
                console.log("FAILED TO LOAD SKETCH");
                clearInterval(mem);
            }

        }
    }, 10);

// get all data from web socket
$(window).ready( function() {


	// connect to the web socket
    var socket = io.connect();
	
	$('body').bind('lookthisup', function(e, arr_ids) { 

		if( lookupNow == true ){
			console.log("Lookup Now ! ");
			socket.emit( 'lookup', { ids : arr_ids } );
			lookupNow = false;
		}
		// console.log(arr_ids); 
	});

    socket.on( 'users', function( data ) {
    	console.log('got some users !');
    	
    	var users = JSON.parse( decodeURIComponent( escape ( data.profiles ) ) );
    	
        $.each( users, function(key, item) {
            //populate seurons with twitter data
            viz.parseUser( item );
        });
    
    	displaySeuron = true;
    });


    socket.on('loading', function( data) {
         console.log( data.text );
    });

    socket.on('done', function( data) {
    	console.log( data.text );
    });

	socket.on('followers', function( data) {
        // console.log(data.data);
        viz.createFollowers( data.data );
    });
	
	socket.on('friends', function( data ) {
        console.log(data);
        viz.createFriends( data.data );
	});
	
	socket.on('timeline', function( data) {
    	viz.analyzeTimeline( data.data );
    });

	socket.on('mentions', function( data) {
		mentions = data;
		// console.log(mentions);
		// viz.analyzeTimeline( daddy, friends );
	});

});


function lookupUsers( lookup ) {
	console.log('lookup');
	lookupNow = true;
	$('body').trigger('lookthisup', { 'ids' : lookup }); // alerts 'bam'
	toLookup = [];
}

// main function to call when processing canvas is ready
function startIt() {

	// create daddy
    if ( userdata ) {
    	viz.goDaddy( userdata );
    }
}