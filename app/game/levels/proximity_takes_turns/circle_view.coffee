define [
  'game/levels/circle_proximity/proxy_view'
  'game/levels/_base'
  'jqueryui/draggable'
],
(
  CircleProximityCircleView
  Level
  x_JqDraggable
) ->

  _freshClass = 'fresh'
  _onDeckClass = 'onDeck'
  _focusClass = 'focus'
  _draggableStackSel = '.ui-draggable'
  _animTriggerClass = 'plop'
  _calculateXYDistance = (p1, p2) ->
    distance =
      x: p1.x - p2.x
      y: p1.y - p2.y
    distance

  View = CircleProximityCircleView.extend

    # ----------------------------------------------------- Class Extensions
    className: "circle #{_freshClass}"
    attributes:
      tabindex: 2
    events:
      mousedown: 'onMousedown'
      touchstart: 'onTouchstart'

    initialize: ->
      _.bindAll @, 'onDragStart', 'onDrag', 'onDragStop'
      @listenTo @model, 'change:focus', @onChangeFocus

    render: ->
      @$el.html @model.attributes.abbreviation
      @$el.prop title:"#{@model.attributes.trait1} / #{@model.attributes.trait2}"
      require ['jquiTouchPunch'], => # This kludge is to support touch on the jqui draggable element. TODO: drag lib with native touch support
        @_makeDraggable()
      @


    # ----------------------------------------------------- Private Methods
    _makeDraggable: ->
      @$el.draggable
        stack: _draggableStackSel
        start: @onDragStart
        drag: @onDrag
        stop: @onDragStop

    _concentrate: ->
      @model.set focus:true
      @

    _animatePlop: ->
      @$el.removeClass _animTriggerClass
      setTimeout (=> @$el.addClass _animTriggerClass), 1 # This delay lets the dom notice and animate the added class

    _updateModelPosition: ->
      coords = @$el.position()
      center = @coordToCenter
        x: coords.left
        y: coords.top
      @model.set
        pos:
          x: center.x
          y: center.y
        left: coords.left
        top: coords.top
        selfProximityPx: Math.round @_calculateDistanceFromSelf center
      @


    # ----------------------------------------------------- Draggable Events
    onDragStart: (e, ui) ->
      @$el.removeClass _onDeckClass
      @$el.removeClass _freshClass
      @_concentrate()
      @options.track Level.EVENTS.moveStart,
        index: @model.collection.indexOf @model
        item: @model.toJSON()

    onDrag: (e, ui) ->
      @_maintainLine(e, ui)

    onDragStop: (e, ui) ->
      @_updateModelPosition()
      @model.set interacted:true
      @_animatePlop()
      @options.track Level.EVENTS.moveEnd,
        index: @model.collection.indexOf @model
        item: @model.toJSON()


    # ----------------------------------------------------- UI Events
    onTouchstart: ->
      @_concentrate()
    onMousedown: ->
      @_concentrate()


    # ----------------------------------------------------- Data Events
    onChangeFocus: (model, isFocused) ->
#      @$el.removeClass _focusClass unless isFocused
      @$el.toggleClass _focusClass, isFocused
      if isFocused and not model.attributes.interacted
        setTimeout (=> @$el.addClass _onDeckClass), 4




  View

