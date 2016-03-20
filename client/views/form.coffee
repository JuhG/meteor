###########################################################################
# CREATED
###########################################################################
# Template.form.created = ->
#   @focus = new ReactiveVar()
#   @focus.set(false)

###########################################################################
# HELPERS
###########################################################################
# Template.form.helpers =

###########################################################################
# EVENTS
###########################################################################
Template.form.events =

  'submit .messages__form': (event) ->
    event.preventDefault()
    if !Meteor.userId()
      $(".error").addClass "submit"
      setTimeout (->
        $(".error").removeClass "submit"
      ), 300   
    else
      name = undefined
      if Meteor.user().profile
        name = Meteor.user().profile.name
      else
        name = Meteor.user().emails[0].address
      userId = Meteor.userId()
      message = document.getElementById('message').value.trim()
      if message != ''
        otherUserId = Session.get('active')
        if otherUserId == 'public'
          Meteor.call 'insertMessage', message, name, userId
        else
          Meteor.call 'insertPrivate', message, name, userId, otherUserId
          Meteor.call 'startConversation', otherUserId, userId, name
        document.getElementById('message').value = ''
        message = ''
        inFocus()
    return

  'focus #message': ->
    if !Meteor.userId()
      $(".error").removeClass "hidden"
      setTimeout (->
        $(".error").addClass "focus"
      ), 10
    else
      $(".error").removeClass "focus"
      setTimeout (->
        $(".error").addClass "hidden"
      ), 1010
      inFocus()


    

inFocus = ->
  active = Session.get('active')
  if active == "public"
    lastMessage = Messages.findOne { userId: $not: Meteor.userId() }, sort: time: -1
    Meteor.call "setLastSeen", Meteor.userId(), lastMessage.time
  else
    Meteor.call 'setRead', Meteor.userId(), active
  return    