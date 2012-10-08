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


# import classes
Seuron = require('../models/Seuron').Seuron
Interaction = require('../models/Interaction').Interaction
Message = require('../models/Message').Message

# Let's use events to prevent annoying nested callbacks 
events = require 'events'

# Add an event emitter
eventEmitter = new events.EventEmitter()

eventEmitter.on 'analyzetweet', (tweet) ->
  console.log "start analyze tweet"

analyzeTimeline = (timeline) ->
  
  # init value for each timelines
  
  for tweet in timeline
    # tweetIds.push[tweet.id]
    analyzeTweet tweet
    eventEmitter.emit 'analyzetweet'


    
  eventEmitter.on 'endAnalyzeTimeline', () ->
    console.log "timeline ok!"
      
  # API twitter lookup users for toLookup<100
  # lookupUsers toLookup  if toLookup.length > 0

analyzeTweet = (tweet) ->
  
  # check what actions can be founded within our tweet
  # 0:unknown, 1:post, 2:RT, 3:reply, 4:@
  
  # create our message
  m = new Message
  m.id = tweet.id
  m.data = tweet
  m.save()
    # console.log "message created"

  # check if our seuron already exists inside the DB
  Seuron.findOne {"sns.twitter.id":tweet.user.id}, (err, seuron) ->
    console.log err if err 
    if(!seuron) 
      from = new Seuron({"sns.twitter.id":tweet.user.id })
      from.save (err)->
        # console.log 'new seuron created'
        checkTweetType from, tweet
    else
      # console.log 'seuron exists'
      checkTweetType seuron, tweet

checkTweetType = (from, tweet) ->

  # our tweet is a reply
  if tweet.in_reply_to_status_id
    
    # console.log("reply");
    analyzeReply from, tweet
    # analyzeThread tweet, tweet.in_reply_to_status_id
  
  # our tweet is a RT
  else if tweet.retweeted_status
    # console.log "RT"
    analyzeRT from, tweet
    # analyzeThread tweet, tweet.retweeted_status.id
  
  # our tweet is just a post
  else 
    # Analyze if there is mentions in this tweet
    # analyzeThread tweet, null

    if tweet.entities.user_mentions.length > 0

      # add message to seuron from
      # findMessageByTwitterId tweet.id, (message) ->

      # from.messages.push message
      analyzeMentions from, tweet.entities.user_mentions, from.sns.twitter.id, tweet

analyzeRT = ( from, tweet ) ->
  
  # we analyze first RT
  # then analyze retweeted_status as a new post
  # console.log "RT"

  # get our guy that has post in the first place
  findOrCreateSeuronWithTwitterId tweet.retweeted_status.user.id, (rtFromSeuron) ->
    
    # update seuron with profile info
    rtFromSeuron.sns.twitter.profile = tweet.retweeted_status.user
    rtFromSeuron.save()

    # create or get existing synapse from reply_guy   
    from.findOrCreateSynapse rtFromSeuron, (synapse) ->

      # console.log synapse
      # Now create our new interaction and add it to our message
      RT = new Interaction {"synapse":synapse, "action":2}
      RT.save (d) ->
        # add interactions to the message
        findMessageByTwitterId tweet.id, (message) ->
          
          message.interactions.push RT
          message.save()

    # add message id to seuron
    from.messages.push tweet.id
    from.save()

  # deal with other users that has been quoted in the message
  if tweet.entities.user_mentions.length > 0

    tempMentions = []

    # add all mentions into an array
    tempMentions.push mention for mention in tweet.entities.user_mentions

    # loop to add other mentions coming form RT status
    
    for rtmention in tweet.retweeted_status.entities.user_mentions 
      for mention in tempMentions
        if rtmention != mention
          tempMentions.push rtmention
    

    analyzeMentions from, tempMentions, tweet.retweeted_status.user.id, tweet

analyzeReply = (from, tweet) ->
  
  # is the message a reply to himself?
  # if tweet.in_reply_to_user_id == from.sns.twitter.id
  #   console.log("this is a reply to myself ! "); --> silly
  
  # get or create the guy from the reply
  findOrCreateSeuronWithTwitterId tweet.in_reply_to_user_id, (replySeuron) ->
    # get or create existing synapse between from and reply guys
    from.findOrCreateSynapse replySeuron, (synapse) ->
      # now get the message and add interactions
      reply = new Interaction {"synapse":synapse, "action":3}
      reply.save (d) ->    
        # add interactions to the message

        findMessageByTwitterId tweet.id, (message) ->
          
          message.interactions.push reply
          message.save()
  
  #add message to seuron
  from.messages.push tweet.id
  from.update()

  # create other relations with guys quoted in the message 
  if tweet.entities.user_mentions.length > 0
    analyzeMentions from, tweet.entities.user_mentions, tweet.in_reply_to_user_id, tweet

analyzeMentions = (from, mentions, exclude_id, tweet) ->
  # console.log tweet.id
  
  # findMessageByTwitterId tweet.id, (message) ->
  #   from.messages.push message
  
  #loop into mentions
  i = 0
  while i < mentions.length

    # exclude id that has been passed 
    if mentions[i].id isnt exclude_id and mentions[i].id isnt from.id
      
      findOrCreateSeuronWithTwitterId mentions[i].id, (replySeuron) ->    
        # console.log replySeuron.sns.twitter.id
        # get existing Friendship 
        from.findOrCreateSynapse replySeuron, (synapse) ->

          at = new Interaction {"synapse":synapse, "action":3}
          at.save (d) ->
            
            # console.log d
            # console.log tweet.id
            # add interactions to the message
            findMessageByTwitterId tweet.id, (message) ->
              # console.log("---mentions")
              # console.log message.interactions
                
              message.interactions.push at
              message.save (err) ->
                # console.log err
                

    i++

analyzeThread = (tweet, prevId) -> 
   
  if prevId !=null
    # console.log "prevId-- "+prevId
    addMessageOrCreateThread prevId
  
  # console.log "tweet.id--" +tweet.id

  addMessageOrCreateThread tweet.id

  # if the tweet is a RT, then analyze the original message
  if tweet.retweeted_status
    # console.log "analyzeTweet RT -- "+tweet.retweeted_status.id
    # analyze original message
    analyzeTweet tweet.retweeted_status
    
  # analyze the previous message / reply 
  else if tweet.in_reply_to_status_id != null
    # console.log "Reply --"+tweet.in_reply_to_status_id

    findMessageByTwitterId tweet.in_reply_to_status_id, (reply) ->

      if(reply == null)
        # console.log reply
        console.log 'should fire twitter API request to get message'
      else
        console.log "go analyzetweet"
        # console.log reply
        analyzeTweet reply

# check if the message already exists in one message thread
# if not, then create a new thread
addMessageOrCreateThread = (previousMessageId) ->
  # console.log "addMessageOrCreateThread fired!"
  Message.find { "thread": previousMessageId }, (err, messagesWithThread) ->

    console.log err if err

    console.log messagesWithThread
    # the thread doesn't already exist in any messages
    if(messagesWithThread.length == 0 ) 

      # get our message
      findMessageByTwitterId previousMessageId, (message) ->
        if(!message)
          console.log 'should create the message'
        else
          # console.log "thread"
          # console.log message
          # console.log message.thread
          # add thread element to our message
          message.thread.push previousMessageId
          # console.log message.thread
          message.save (d) ->
            console.log "thread created"

    else # this thread already exist in one or several messages
       # add our message to thread
       for message in messagesWithThread
        # console.log "message   -"+message
        message.thread.push previousMessageId
        message.save (d) ->
          console.log "added to thread"

findOrCreateSeuronWithTwitterId = (twitterId, callback) ->
  
  Seuron.findOne {"sns.twitter.id": twitterId}, (err, seuron) ->
    console.log err if err
    if !seuron
      s = new Seuron
      s.sns.twitter.id= twitterId
      s.save (d) ->
        callback(s)
        # console.log "seuron created!"
    else
      # console.log "seuron found!"
      callback(seuron)

findMessageByTwitterId = (messageId, callback) ->
  # console.log "---"+messageId

  Message.findOne {"id" : messageId}, (err, message) ->
      console.log err if err
      if(message)
        callback( message )
      else
        console.log "findMessageByTwitterId : missing functions should be fixed !!!"
        callback( null )
        # if the message doesn't exist, we should 
        # 1. create it from timeline mentions
        # 2. get it from twitter timeline !


# Exports functions to the outside world
module.exports =
  analyzeTimeline:analyzeTimeline
  analyzeTweet:analyzeTweet