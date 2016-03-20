Meteor.publish 'messages', ->
  Messages.find {}

Meteor.publish 'privats', ->
  Privats.find userId: @userId
  
Meteor.publish 'conversations', ->
  Conversations.find userId: @userId
  
Meteor.publish 'lastSeen', ->
  LastSeen.find userId: @userId

Meteor.publish null, ->
  Meteor.users.find {},
		fields:
			profile: 1
			emails: 1