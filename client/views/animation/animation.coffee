Template.messages.rendered = ->
  @$('.messages__list')[0]._uihooks = {
    insertElement: (node, next) ->
      $(node).addClass('hidden').insertBefore(next)
      Tracker.afterFlush ->
        setTimeout (->
          $(node).removeClass('hidden')
        ), 10
    removeElement: (node) ->
      $(node).addClass("hidden").remove()
  }

Template.sidebar.rendered = ->
  @$('.sidebar')[0]._uihooks = {
    insertElement: (node, next) ->
      $(node).addClass('hidden').insertBefore(next)
      Tracker.afterFlush ->
        setTimeout (->
          $(node).removeClass('hidden')
        ), 10
    removeElement: (node) ->
      $(node).addClass("hidden")
      setTimeout (->
        $(node).remove()
      ), 510
  }