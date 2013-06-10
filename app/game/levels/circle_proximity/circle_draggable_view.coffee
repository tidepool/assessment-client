define [
  'backbone'
  'Handlebars'
  './circle_view'
  'jqueryui/draggable'
],
(
  Backbone
  Handlebars
  CircleView
  x_jqDraggable
) ->

  _draggableSel = '.circle.ui-draggable'
  _animationTriggerClass = 'yay'
  _selfSel = '.self'

  _me = 'game/levels/circle_proximity/circle_draggable_view'
  View = CircleView.extend

    # ----------------------------------------------------- Backbone Extensions
    className: 'circle draggable'
    initialize: ->
      _.bindAll @, 'onStartDrag', 'onDrag', 'onStopDrag'
      @origin = @model.get 'pos'
      @listenTo @model, 'change:pos', @onChangePos
    render: ->
      @$el.html @model.get 'abbreviation'
      @setClassBySize @model.get 'size'
      @_positionCircle @model.attributes.pos
      @


    # ----------------------------------------------------- Private Methods
    _positionCircle: (position) ->
      @$el.css
        left: position.x
        top: position.y

    _updateModelPosition: (e, ui) ->
      @model.set 'pos'
        x: ui.position.left
        y: ui.position.top

    _showLine: ->
      @model.$line.show()
      @pxSize = @$el.width()

    _maintianLine: (e, ui) ->
      circleCenter = @model.positionToCenter
        x: ui.position.left
        y: ui.position.top
#      circleCenter =
#        x: ui.position.left + @pxSize/2
#        y: ui.position.top + @pxSize/2
      originCenter = @model.positionToCenter @origin
      distance =
        x: circleCenter.x - originCenter.x
        y: circleCenter.y - originCenter.y
      # Pythag, yo
      length = Math.sqrt( distance.x * distance.x + distance.y * distance.y )
      # Trigga happy
      angle = 180 / Math.PI * Math.acos( distance.y / length )
      angle *= -1 if distance.x > 0
      # Apply the magic numbers to actual screen shapes
      @model.$line.css
        height: length
        '-webkit-transform': "rotate(#{angle}deg)"
        '-moz-transform': "rotate(#{angle}deg)"
        '-o-transform': "rotate(#{angle}deg)"
        '-ms-transform': "rotate(#{angle}deg)"
        'transform': "rotate(#{angle}deg)"

    _hideLine: ->
      @model.$line.hide()

    _shimmerSelf: ->
      $self = @$el.parent().find(_selfSel)
      $self.removeClass _animationTriggerClass
      setTimeout ->
        $self.addClass _animationTriggerClass
        , 1 # This delay lets the dom notice and animate the added class


    # ----------------------------------------------------- Event Callbacks
    onStartDrag: ->
      #console.log "#{_me}.onStartDrag"
      @_showLine()
      @model.$label.addClass 'active'
    onDrag: (e, ui) ->
      #console.log "#{_me}.onDrag"
      @_maintianLine(e, ui)
    onStopDrag: (e, ui) ->
      #console.log "#{_me}.onStopDrag"
      @_hideLine()
      @_updateModelPosition(e, ui)
      @_shimmerSelf()
      @model.$label.removeClass 'active'
    onChangePos: (model) ->
      newPos = @model.get 'pos'
      console.log "#{_me}.onChangePos(): Original: #{@origin.x}, #{@origin.y} New: #{newPos.x}, #{newPos.y}"


    # ----------------------------------------------------- Public API
    makeDraggable: ->
      @$el.draggable
        stack: _draggableSel
        start: @onStartDrag
        drag: @onDrag
        stop: @onStopDrag


  View




