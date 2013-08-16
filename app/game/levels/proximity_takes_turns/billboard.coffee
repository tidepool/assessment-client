define [
  'backbone'
],
(
  Backbone
) ->



  View = Backbone.View.extend

    # ----------------------------------------------------- Backbone Extensions
    className: 'billboard'

    initialize: ->

    render: ->
      @

    # ----------------------------------------------------- Private Methods

    # ----------------------------------------------------- UI Events


    # ----------------------------------------------------- Data Events

    # ----------------------------------------------------- Consumable API
    slideIn: -> # slide new text in with a circle
    focusOut: -> # drop the current text down
    focusIn: -> # bring new text up and in


  View

