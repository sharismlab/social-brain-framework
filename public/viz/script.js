var allMessages = [];
var allUsers= [];
var userTimeline = [];
// console.log( userdata );

$(window).load(function() {

    var socket = io.connect(); // TIP: .connect with no args does auto-discovery
    
    // console.log ( userTimeline.length() );

    if( userdata && userTimeline.length == 0 ) {
        console.log (' get userTimeline');
        socket.emit('getTimeline', { userID : userdata.id }, function (data) {
            
            var userTimeline = data;

            console.log(data); // fresh data from the server
        });
    }
    

    socket.on('userlookup', function( data) {
         console.log( data );
    });


    socket.on('limitRate', function( data) {
        console.log( data );
        $('a.counter').html( data.data.remaining_hits + " hits remain" );
    });


    var viz = Processing.getInstanceById("seuron");
    
    //get all messages
    //$.getJSON( userdata.status , function(data) {

        // $.each( userdata.status, function(key, item) {
            if ( userdata ) {
                item = userdata.status;

                // add tweets into js array
                allMessages.push(item);

                // send msg data to processing

                // console.log(viz);
                if(viz != null) 
                setTimeout(function(){ viz.analyzeTweet(item) }, 5000);
            }

        // });
    //}); 

}); // end document ready
