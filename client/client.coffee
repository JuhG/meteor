Meteor.subscribe 'messages'
Meteor.subscribe 'privats'
Meteor.subscribe 'conversations'
Meteor.subscribe 'lastSeen'

Meteor.startup ->
  Session.set 'active', 'public'
  return