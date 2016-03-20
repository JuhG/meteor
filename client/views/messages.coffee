###########################################################################
# HELPERS
###########################################################################
Template.messages.helpers

  messages: ->
    active = Session.get('active')
    if active == 'public'
      Messages.find {}, sort: time: -1
    else
      Privats.find { other: active }, sort: time: -1

  time: ->
    moment(@time).fromNow()
    
  getRead: ->
    active = Session.get('active')
    if active != 'public'
      @read == false
    else
      if @userId != Meteor.userId()
        lastMessage = LastSeen.find().fetch()
        if Object.keys(lastMessage).length != 0
          readPublic = true if lastMessage[0].messageTime < @time
        readPublic

  getIfItIsMyMessage: ->
    active = Session.get('active')
    if active == "public"
      @userId == Meteor.userId()
    else
      @sender == true


###########################################################################
# EVENTS
###########################################################################
Template.messages.events =

'click .msg__name': (event) ->
  if Meteor.userId()
    userId = Meteor.userId()
    id = event.currentTarget.dataset.id
    if userId != id
      name = event.currentTarget.innerHTML
      ownName = undefined
      if Meteor.user().profile
        ownName = Meteor.user().profile.name
      else
        ownName = Meteor.user().emails[0].address
      if !Conversations.find(
          userId: userId
          other: id).count()
        Meteor.call 'startConversation', userId, id, name
      Session.set 'active', id