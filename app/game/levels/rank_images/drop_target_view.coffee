define [
  'backbone'
  'Handlebars'
],
(
  Backbone
  Handlebars
) ->

  _me = 'game/levels/rank_images/drop_target_view'

  View = Backbone.View.extend

    # ----------------------------------------------------- Backbone Extensions
    className: 'dropTarget'
    initialize: ->
    render: ->
      @$el.text @options.rank
      @

    # ----------------------------------------------------- Private Methods
    _bindEvents: ->


    # ----------------------------------------------------- Event Callbacks
    onSuccessfulDrop: (e, ui) ->
      #$(this).addClass 'paired'

    onDragOut: (e, ui) ->
      #$(this).removeClass 'paired'





  View




