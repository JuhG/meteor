isPublic= ->  
  active = Session.get "active"
  active == "public"

###########################################################################
# HELPERS
###########################################################################
Template.sidebar.helpers

  privats: ->
    Conversations.find()

  time: ->
    moment(@time).fromNow()

  unreadPublic: ->
    lastMessage = Messages.findOne {}, sort: time: -1
    if lastMessage
      if lastMessage.userId != Meteor.userId()
        lastSeenMessage = LastSeen.find().fetch()
        if Object.keys(lastSeenMessage).length != 0
          lastMessage.time != lastSeenMessage[0].messageTime

  unread: ->
    Privats.find(
      userId: Meteor.userId()
      other: @other
      read: false).count() != 0

  isActive: ->
    if !isPublic()
      active = Session.get "active"
      active == @other

  isActivePublic: ->
    isPublic()

  allUsers: ->
    conv = Conversations.find().fetch()
    names = [Meteor.userId()]
    for name in conv
      names.push name.other
    Meteor.users.find( _id: { $nin: names } )


###########################################################################
# EVENTS
###########################################################################
Template.sidebar.events =

'click .sidebar__block': (event) ->
  if Meteor.userId()
    id = event.currentTarget.dataset.id
    Session.set 'active', id

'click .sidebar__block__closer': (event) ->
  id = event.currentTarget.parentNode.dataset.id
  userId = Meteor.userId()
  active = Session.get "active"
  Meteor.call 'endConversation', userId, id
  setTimeout (->
    if active == id
      Session.set "active", "public"
    else
      Session.set "active", active
  ), 10

'click .sidebar__other-user': (event) ->  
  if Meteor.userId()
    userId = Meteor.userId()
    id = event.currentTarget.dataset.id
    console.log id
    if userId != id
      name = event.currentTarget.innerHTML
      if !Conversations.find(
          userId: userId
          other: id).count()
        Meteor.call 'startConversation', userId, id, name