define [
  'underscore'
  'backbone'
  'Handlebars'
  'text!./proxy_view.hbs'
  'jqueryui/draggable'
],
(
  _
  Backbone
  Handlebars
  tmpl
  x_JqDraggable
) ->

  _me = 'game/levels/circle_proximity/proxy_view'
  _circleSel = '.circle'
  _animationTriggerClass = 'yay'
  _showLabelClass = 'showLabel'
  _draggableStackSel = '.ui-draggable'
  _USEREVENTS =
    dragStart: 'circle_start_move'
    dragStop: 'circle_end_move'
  _calculateXYDistance = (p1, p2) ->
    distance =
      x: p1.x - p2.x
      y: p1.y - p2.y
    distance



  View = Backbone.View.extend

    # ----------------------------------------------------- Backbone Extensions
    className: "proxy #{_showLabelClass}"
    tmpl: Handlebars.compile tmpl
    initialize: ->
      _.bindAll @, 'onDragStart', 'onDrag', 'onDragStop'
    render: ->
      @$el.html @tmpl @model.attributes
      @$(_circleSel).addClass @model.sizeToClass[@model.attributes.size]
      @_makeDraggable()
      @


    # ----------------------------------------------------- Private Methods
    _makeDraggable: ->
      @$el.draggable
        handle: _circleSel
        stack: _draggableStackSel
        start: @onDragStart
        drag: @onDrag
        stop: @onDragStop

    _shimmerSelf: ->
      return unless @options.selfView?.$el
      @options.selfView.$el.removeClass _animationTriggerClass
      setTimeout =>
        @options.selfView.$el.addClass _animationTriggerClass
        , 1 # This delay lets the dom notice and animate the added class

    _showLine: ->
      return unless @options.$line?
      @options.$line.show()

    _maintainLine: (e, ui) ->
      return unless @options.$line?
      moving = @coordToCenter
        x: ui.position.left
        y: ui.position.top
      length = @_calculateDistanceFromSelf moving
      # Normalize length to 0-1 scale
      opacity = (length - 200) / (400 - 200)
      opacity = 1 if opacity > 1
      opacity = 0 if opacity < 0
      opacity = 1 - opacity
      # Trigga happy
      distance = _calculateXYDistance moving, @options.selfView.getSelfCenter()
      angle = 180 / Math.PI * Math.acos( distance.y / length )
      angle *= -1 if distance.x > 0
      # Apply the magic numbers to actual screen shapes
      @options.$line.css
        height: length
        opacity: opacity
        '-webkit-transform': "rotate(#{angle}deg)"
        '-moz-transform': "rotate(#{angle}deg)"
        '-o-transform': "rotate(#{angle}deg)"
        '-ms-transform': "rotate(#{angle}deg)"
        'transform': "rotate(#{angle}deg)"

    _hideLine: ->
      return unless @options.$line?
      @options.$line.hide()

    _calculateDistanceFromSelf: (circleCenter) ->
      self = @options.selfView.getSelfCenter()
      distance = _calculateXYDistance circleCenter, self
      # Pythag, yo
      crowFlies = Math.sqrt( distance.x * distance.x + distance.y * distance.y )

    _updateModelSelfOverlap: ->
      selfRad = @options.selfView.getSelfRadius()
      circleRad = @getCircleSize() / 2
      distance = @model.get 'selfProximityPx'
      if distance < selfRad + circleRad
        overlapPx = selfRad + circleRad - distance # Distance from center of circle to edge of self
        overlapPx = circleRad * 2 if overlapPx > circleRad * 2 # The maximum overlap is the diameter of the circle
      else
        overlapPx = null
      overLapRatio = overlapPx / (circleRad * 2)
#      console.log
#        circleRad: circleRad
#        overlapPx: overlapPx
#        overLapRatio: overLapRatio
      @model.set
        selfOverlapPx: overlapPx
        selfOverlapRatio: overLapRatio

    _updateModelPosition: (coords) ->
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
      @_updateModelSelfOverlap()
      #console.log @model.attributes


    # ----------------------------------------------------- Event Callbacks
    onChangePos: (model, pos) ->

    onDragStart: (e, ui) ->
      @$el.removeClass(_showLabelClass)
      @_showLine()
      @options.track?(
        event_desc: _USEREVENTS.dragStart
        circle_no: @model.collection.indexOf @model
        circle: @model.toJSON()
      )

    onDrag: (e, ui) ->
      @_maintainLine(e, ui)

    onDragStop: (e, ui) ->
      @_shimmerSelf()
      @_hideLine()
      @_updateModelPosition ui.position
      @options.track?(
        event_desc: _USEREVENTS.dragStop
        circle_no: @model.collection.indexOf @model
        circle: @model.toJSON()
      )


    # ----------------------------------------------------- Public API
    positionByCenter: (centerPos) ->
      coords = @centerToCoord centerPos
      @$el.css
        left: Math.round coords.x
        top: Math.round coords.y

    getCircleSize: ->
      @_width = @_width || @$(_circleSel).width() # We use this method a lot, and the el width should stay the same during the object's life, so cache it
      @_width

    coordToCenter: (coord) ->
      radius = @getCircleSize() / 2
      center =
        x: coord.x + radius
        y: coord.y + radius

    centerToCoord: (center) ->
      radius = @getCircleSize() / 2
      coord =
        x: center.x - radius
        y: center.y - radius



  View




