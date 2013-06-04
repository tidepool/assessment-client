define [
  'backbone'
  'Handlebars'
  'jqueryui/droppable'
],
(
  Backbone
  Handlebars
  Droppable
) ->

  _valignFudgeFactor = -7
  _halignFudgeFactor = -4
  _me = 'game/levels/rank_images/drop_target_view'

  View = Backbone.View.extend

  # ----------------------------------------------------- Backbone Extensions
    className: 'dropTarget'
    initialize: ->
    render: ->
      @$el.text @options.rank
      @$el.droppable
        activeClass: 'nearby'
        hoverClass: 'onTarget'
        drop: @onSuccessfulDrop
        out: @onDragOut
      @


    # ----------------------------------------------------- Private Methods
    _bindEvents: ->
#      @listenTo @draggie, 'dragStart', @onDragStart
#      @listenTo @draggie, 'dragMove', @onDragMove
#      @listenTo @draggie, 'dragEnd', @onDragEnd


    # ----------------------------------------------------- Event Callbacks
    onSuccessfulDrop: (e, ui) ->
      $(this).addClass 'paired'
      offset = $(this).offset()
      offset.top += _valignFudgeFactor
      offset.left += _halignFudgeFactor
      $(ui.draggable).offset offset
      $(this).droppable 'option', 'accept', ui.draggable # Only allow one item to be in each drop area

    onDragOut: (e, ui) ->
      $(this).droppable 'option', 'accept', '*'
      $(this).removeClass 'paired'





  View




