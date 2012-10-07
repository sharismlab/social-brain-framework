###
ANALYSE EACH TWEET OF THE TIMELINE
-------------------------------

    Now we need to analyze each message to extract
        - quoted people ( @ )
        - nature of the message ( post / RT / answer)

    The message is the only proof of an existing relationship.
    So our messages will be attached to a relationship (Dendrit), not a user.

    What we need to achieve : 
        
        - Extract actions from message 
            Actions are defined by the following int
            0 :     unknown
            1 :     post
            2 :     RT
            3 :     answer
            4 :     quote(s)

            ex : 
                @Makio135 says : "RT @jbjoatton: The Isolator vs @iAWriter http://t.co/jwBjDHdO"
                
                //extract entities
                create or get seurons for @Makio135, @jbjoatton & @iAWriter

                // store RT 
                Synapse s1 = new Synapse( @Makio135, @jbjoatton, @Makio135.getFriendship( @jbjoatton ) );
                m1 = new Message ( twitter, s1, RT, data )

                // then store quote
                Synapse s2 = new Synapse( @jbjoatton, @iAWriter, 0 );
                m2 = new Message ( twitter, s1, 4, data )


        - When parsing actions, we need to extract all quoted people ( from Twitter Entities )
            add Message to an existing Dendrit 
            or maybe create Dendrits 

        - Messages should be created using the Message class
        - We should populate a global Array with all messages
###

currentThreadIndex = null

# import classes
Seuron = require('../models/Seuron').Seuron
Interaction = require('../models/Interaction').Interaction
Message = require('../models/Message').Message

# import controllers
# seuron_functions = require('../controllers/seurons_controller')
# message_functions = require('../controllers/messages_controller')


analyzeTimeline = (timeline) ->

  # console.log timeline

  console.log "timeline.length : " + timeline.length 
  # console.log("mentions.length : " +timelineMentions.length );

  i = 0

  while timeline[i]
    currentThreadIndex = null
    analyzeTweet timeline[i]
    i++
  
  # API twitter lookup users for toLookup<100
  # lookupUsers toLookup  if toLookup.length > 0

analyzeTweet = (tweet) ->
  
  # check what actions can be founded within our tweet
  # 0:unknown, 1:post, 2:RT, 3:reply, 4:@
  # console.log(tweet.created_at);
  
  # create our message
  m = new Message
  m.id = tweet.id
  m.data = tweet
  m.save (d) ->
    console.log "message created"

    # check if our seuron already exists inside the DB
    Seuron.findOne {"sns.twitter.id":tweet.user.id}, (err, seuron) ->
      console.log err if err 
      if(!seuron) 
        from = new Seuron({"sns.twitter.id":tweet.user.id })
        from.save (d)->
          console.log 'new seuron created'
          checkTweetType from, tweet
      else
        # console.log 'seuron exists'
        checkTweetType seuron, tweet
   
checkTweetType = (from, tweet ) ->

  # our tweet is a reply
  if tweet.in_reply_to_status_id?
    
    # console.log("reply");
    analyzeReply from, tweet
    analyzeThread tweet, tweet.in_reply_to_status_id
  
  # our tweet is a RT
  else if tweet.retweeted_status
    analyzeRT from, tweet
    analyzeThread tweet, tweet.retweeted_status.id
  
  # our tweet is just a post
  else    
    # console.log("mentions");
    # Analyze if there is mentions in this tweet
    analyzeThread tweet, null
    analyzeMentions from, tweet.entities.user_mentions, from.sns.twitter.id, tweet  if tweet.entities.user_mentions.length > 0

analyzeRT = ( from, tweet ) ->
  
  # we analyze first RT
  # then analyze retweeted_status as a new post
  console.log "RT"

  # get our guy that has post in the first place
  findOrCreateSeuronWithTwitterId tweet.retweeted_status.user.id, (rtFromSeuron) ->
    
    # update seuron with profile info
    rtFromSeuron.sns.twitter.profile = tweet.retweeted_status.user
    rtFromSeuron.save()
    # console.log from 
    # create or get existing synapse from reply_guy   
    from.findOrCreateSynapse rtFromSeuron, (synapse) ->
      console.log synapse
      # Now create our new interaction and add it to our message
      RT = new Interaction {"synapse":synapse, "action":2}
      RT.save (d) ->
        console.log "alalalala"
        # add interactions to the message
        findMessageByTwitterId tweet.id, (message) ->
          console.log 'interaction added'
          message.interactions.push RT
          #add message to seuron
          from.messages.push tweet.id

###
    # deal with other users that has been quoted in the message
    if tweet.entities.user_mentions.length > 0
      tempMentions = []
      i = 0

      while i < tweet.entities.user_mentions.length
        tempMentions.push tweet.entities.user_mentions[i]
        i++
      mentionExist = undefined
      j = 0

      while j < tweet.retweeted_status.entities.user_mentions.length
        mentionExist = false
        i = 0

        while i < tweet.entities.user_mentions.length
          mentionExist = true  if tweet.retweeted_status.entities.user_mentions[j] is tweet.entities.user_mentions[i].id
          i++
        tempMentions.push tweet.retweeted_status.entities.user_mentions[j]  unless mentionExist
        j++
      analyzeMentions _from, tempMentions, tweet.retweeted_status.user.id, tweet
###

findOrCreateSeuronWithTwitterId = (twitterId, callback) ->
  
  Seuron.findOne {"sns.twitter.id": twitterId}, (err, seuron) ->
    console.log err if err
    if !seuron
      s = new Seuron
      s.sns.twitter.id= twitterId
      s.save (d) ->
        callback(s)
        console.log "seuron created!"
    else
      callback(seuron)


findMessageByTwitterId = (messageId, callback) ->
  console.log "---"+messageId

  Message.findOne {"id" : messageId}, (err, message) ->
      console.log err if err
      callback( message )


analyzeReply = ( _from, tweet ) ->
    # console.log "reply"

analyzeMentions = ( _from, mentions, exclude_id, data  ) ->
    # console.log "mentions"

analyzeThread = ( tweet, prevId ) ->
    # console.log "thread"





# Exports functions to the outside world
module.exports =
  analyzeTimeline:analyzeTimeline
  analyzeTweet:analyzeTweet