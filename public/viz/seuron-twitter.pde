/*
	   _____ ____  _____________    __       _   __________  ______  ____  _   __
	  / ___// __ \/ ____/  _/   |  / /      / | / / ____/ / / / __ \/ __ \/ | / /
	  \__ \/ / / / /    / // /| | / /      /  |/ / __/ / / / / /_/ / / / /  |/ / 
	 ___/ / /_/ / /____/ // ___ |/ /___   / /|  / /___/ /_/ / _, _/ /_/ / /|  /  
	/____/\____/\____/___/_/  |_/_____/  /_/ |_/_____/\____/_/ |_|\____/_/ |_/                          
	        _                  ___             __  _           
	 _   __(_)______  ______ _/ (_)___  ____ _/ /_(_)___  ____ 
	| | / / / ___/ / / / __ `/ / /_  / / __ `/ __/ / __ \/ __ \
	| |/ / (__  ) /_/ / /_/ / / / / /_/ /_/ / /_/ / /_/ / / / /
	|___/_/____/\__,_/\__,_/_/_/ /___/\__,_/\__/_/\____/_/ /_/ 
	                                                           
	   ___   ____ ______ 
	  |__ \ / __ <  /__ \
	  __/ // / / / /__/ /
	 / __// /_/ / // __/ 
	/____/\____/_//____/ 
	                     
	processing + twitter + jquery 
*/
var cnvs, ctx;

PFont font = loadFont("Comic Sans");
 
/////////// DECLARE  ALL VARS

	// A global array to store all seurons
	var seurons = [];

	// A simple array storing only ids for all seurons
	var seuronIds = [];

	// Array to store all ids that needs to be looked up through twitter API
	var toLookup = [];

	// all our messages Ids
	var messageIds = [];

	// all our messages 
	var messages = [];
	var messagesLookup = []

	// store all our messages
	var interactions = [];
	var interactionIds = [];

	// store all our messages
	var threads = [];
	var timelineMentions = [];

	// THE Only boss of all.
	Seuron daddy;
	
	// to dispaly messages
	boolean showInteraction = false;
	boolean displaySeuron = false; // just turn this on to show seuron
	// boolean displaySeuron = false; // just turn this on to show seuron

// ------------------------------- INIT
void setup(){

	size(screenWidth, screenHeight);
	cnvs = externals.canvas;
	ctx = externals.context;

	// DRAW BACKGROUND
	var gradient = ctx.createRadialGradient( width/2, height/2, 0, width/2, height/2, width*0.5); 
	gradient.addColorStop(0,'rgba(80, 80, 80, 1)');
	gradient.addColorStop(1,'rgba(10, 10, 10, 1)'); 
	ctx.fillStyle = gradient; 
	ctx.fillRect( 0, 0, width, height );

	// console.log(PFont.list());
	font = loadFont("sans-serif");
	textFont(font,48);
	textAlign(CENTER);
	text("LOADING DATA", width/2,height/2);

	textFont(font, 12);


	frameRate(10);
	smooth();
}

// create daddy when we got the right data
void goDaddy( Object daddyData ) {
		daddy = new Seuron( daddyData.id, daddyData, true );
		daddy.cx = width/2;
		daddy.cy = height/2;
		daddy.couleur = #ffffcb;
		seurons.push(daddy);
		seuronIds.push(daddy.id);
		displayDaddy =true;
}

// FRIENDS & FOLLOWERS 
void createFriends( Object data ) {
	console.log("friends : "+data.length);
	daddy.friends = data;
}

void createFollowers( Object data ) {
	console.log("followers : "+data.length);
	daddy.followers = data;
}

void addTimelineMentions( Array data ) {
	for (int i = 0; data[i]; i++){
		timelineMentions.push(data[i]);
	}

}