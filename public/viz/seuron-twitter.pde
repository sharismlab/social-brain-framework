/*
SOCIAL NEURON visualization
processing + twitter + jquery 
2012
*/

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

	// THE Only boss of all.
	Seuron daddy;

	// to dispaly messages
	boolean showMessage = false;

// ------------------------------- INIT
void setup(){
	size(screenWidth, screenHeight);
	background(255);
	textFont(font, 12);
	frameRate(10);
	smooth();

	// for the caption
	colors = [ color(255, 255, 255), color(255, 0, 0), color(0, 255, 0), color(0, 0, 255), color(102, 85, 100) ];
	captions = [
		"Unknown",
		"Friend & Follow", 
		"is Friend of", 
		"is Followed by",
		"No existing relationship"
		];
	
}


// ------------------------------- MAIN DRAWING FUNCTION
void draw() {
	////////////////////////////////////////////////////////////////

	// DRAW BACKGROUND
	var gradient = externals.context.createRadialGradient( width/2, height/2, 0, width/2, height/2, width*0.5); 
	gradient.addColorStop(0,'rgba(80, 80, 80, 1)');
	gradient.addColorStop(1,'rgba(10, 10, 10, 1)'); 
	externals.context.fillStyle = gradient; 
	externals.context.fillRect( 0, 0, width, height ); 

	/*
	// add a loader to screen
	if( loading ) {
		console.log(loading)
		textAlign(CENTER);
		text(isLoading, width/2, height/2);		

	}*/

	// DRAW TIMELINE
	drawTimeline();

	// draw caption
	 color(65);
	 text("PRESS MOUSE BUTTON TO SHOW MESSAGES", screenWidth-300,40);
	 text("Caption", screenWidth-100,60);
	 for (int i = 0; colors[i]; i++){
	 	fill( colors[i] ) ;
	 	text( captions[i], screenWidth-100, i*15+90 ) ;
	 }

	// draw daddy
	daddy.cy =50;
	daddy.cx =screenWidth/2;
	daddy.display();

	// DISPLAY OUR GUYS
	if( disp == true) display();
}



void display(){

	// drawSeurons
	friends = daddy.getFriends();
	followers = daddy.getFollowers();
	close  =daddy.getCloseFriends();

	// draw friends
	for (int i = 0; friends[i]; i++){

		float r = 50;

		float angle = i * TWO_PI / friends.length;

  		float x = cx + cos(angle) * r;
  		float y = cy + sin(angle) * r;
		
		s.cy = y;
		s.cx = x;

		s.display();
	 	
	} 

	for (int i = 0; seurons[i]; i++){

		// console.log(daddy);
		s =  seurons[i];

		if( s.data != null ) {
			
			int level =  daddy.getSynapse(s.id).level;

			// console.log(level);

			float y = (level+1)*( (screenHeight-230 ) /4 );
			float x = i*(screenWidth/seurons.length);
			
			s.cy = y;
			s.cx = x;

			s.display();

		}
		
	}



	//draw synapses
	for (int i = 0; daddy.synapses[i]; i++){
		if(daddy.synapses[i].seuronB.data != null)
			daddy.synapses[i].display();
	}


	//draw messages
	if( showMessage ) {
		for (int i = 0; messages[i]; i++){
			 	
			messages[i].display();
	
		 }
	}

	 if(mousePressed) {
	 	showMessage = true;
	 } else {
	 	showMessage = false;
	 }
}


int dateMin = (new Date()).getTime(); // Return the number of milliseconds since 1970/01/01:
int dateMax = 0;
int seconds;
float descHeight;
float TimelinePosX=0, TimelinePosY=0;
void drawTimeline(){
	externals.context.save();
	rectMode(CORNER);
	fill(100);
	noStroke();
	externals.context.shadowOffsetX = 0;
	externals.context.shadowOffsetY = 0;
	externals.context.shadowBlur = 10;
	externals.context.shadowColor = "black";
	rect(15,height-75,width-30,60);

	fill(0,80);
	rect(15,height-75,20,60);
	externals.context.restore();
	pushMatrix();
	translate(29,height-45);
	rotate(-Math.PI/2);
	fill(255);
	text("Timeline",0,0);
	popMatrix();

	for (int i= 1; seurons[i]; i++){

		Seuron s = seurons[i];
		seconds = Date.parse(s.date);
		if(seconds<dateMin){
			dateMin = seconds;
			// println("dateMin: " + dateMin);
		}
		else if(seconds>dateMax){ 
			dateMax = seconds;
			// println("dateMax: " + dateMax);
		}

		TimelinePosX = map(seconds,dateMin,dateMax,45,width-25);
		TimelinePosY = height-75 + map(s.cy,100,screenHeight-150,5,55);
		stroke(s.couleur);
		strokeWeight(2);
		strokeCap(SQUARE);
		line(TimelinePosX, height-75, TimelinePosX, height-16);
		fill(s.couleur);
		ellipse(TimelinePosX,TimelinePosY,8,8);

		if(dist(mouseX, mouseY, TimelinePosX, TimelinePosY)<8 || dist(mouseX, mouseY, s.cx, s.cy)<s.radius/2) {
			line(TimelinePosX, TimelinePosY, s.cx, s.cy);
			if(textWidth(s.description)>10) descHeight=1+floor(textWidth("Description: "+s.description)/400);
			else descHeight=0;
			fill(255,255,0,150);
			noStroke();
			rect(15,15,460,33+descHeight*14);
			fill(255);
			textAlign(LEFT);
			text("User: "+s.name+"\nDate: "+s.date+"\nDescription: "+s.description,20,20,400,30+descHeight*14);
		}
	}
}