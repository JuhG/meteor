Meteor.startup ->
  Meteor.methods

    'insertMessage': (message, name, userId) ->
      Messages.insert
        userId: userId
        name: name
        message: message
        time: Date.now()
      return

    'insertPrivate': (message, name, userId, otherUserId) ->
      read = false
      otherread = true
      if userId == @userId
        read = true
        otherRead = false
      Privats.insert
        userId: userId
        sender: true
        other: otherUserId
        name: name
        message: message
        read: read
        time: Date.now()
      Privats.insert
        userId: otherUserId
        sender: false
        other: userId
        name: name
        message: message
        read: otherRead
        time: Date.now()
      return

    'startConversation': (userId, otherUserId, name) ->
      if !Conversations.find({ userId: userId, other: otherUserId }).count()
        Conversations.insert
          userId: userId
          other: otherUserId
          name: name

    'endConversation': ( userId, otherUserId) ->
      Conversations.remove
        userId: userId
        other: otherUserId
      return

    'setRead': (userId, otherUserId) ->
      Privats.update {
        userId: userId
        other: otherUserId
      }, { $set: read: true }, multi: true
      return

    "setLastSeen": ( userId, messageTime) ->
      LastSeen.update {
        userId: userId
      }, {
        $set: messageTime: messageTime
      },
        upsert: true
      return



  return