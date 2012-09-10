ArrayList<Seuron> seurons = new ArrayList();
ArrayList<String> seuronId = new ArrayList();
ArrayList<String> lookup = new ArrayList();


// function to add a new Tweet
void analyzeTweet( Object data ) {
	
	console.log(data);

	// check if seurons already exists
	int index = seuronId.indexOf(data.user.id);
	if( index!=-1 ) {
			// println(index);
			Seuron s = seurons.get(index);
			//add message to list
			s.addMessage( new Message (twitterTransmitter , data) );
			exist=true;
	} 

	else {

		seurons.add( new Seuron( random(20,canvasWidth-50), random(100, canvasHeight-150), 35, color(random(255),random(255),random(255)), data ) );
		Seuron s = seurons.get(seurons.size()-1);
		s.addMessage( new Message (twitterTransmitter , data) );
		seuronId.add(s.id);
	}

	if(data.entities.user_mentions.length>0){
		// console.log(data.entities.user_mentions.length);
		for (int i = 0; i<data.entities.user_mentions.length; i++){
			//console.log(data.entities.user_mentions[i]);

			int index2 = seuronId.indexOf(data.entities.user_mentions[i].id);
			//console.log(index2);
			int index3 = lookup.indexOf(data.entities.user_mentions[i].id);
			//console.log(index3);
			if(index2==-1 && index3==-1){
				lookup.add(data.entities.user_mentions[i].id);
				seuronId.add(data.entities.user_mentions[i].id);
				// println("lookup.size(): "+lookup.size());
				// println("seuronId.size(): "+seuronId.size());
			}
		}
	}

	if( lookup.size() == 100 ) {
		loadLookup();
		lookup = new ArrayList;
	}

}

void loadLookup() {

	String url = "https://api.twitter.com/1/users/lookup.json?include_entities=true";
	url += "&user_id=";
	for (int i = 0; i<lookup.size()-1; i++){
		url += lookup.get(i) + ",";

	}
	url += lookup.get( lookup.size()-1 );

	// console.log(url);
	url="datasamples/makio135_lookup.json";
	$.getJSON(url, function(data) {
		$.each( data, function(key, item) {

			item.isProfile =true;
			// allUsers.push( item );
			seurons.add( new Seuron( random(20,canvasWidth-50), random(100, canvasHeight-150), 35, color(random(255),random(255),random(255)), item ) );

		});
	});
}