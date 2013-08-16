define [
  'underscore'
  'backbone'
  'entities/circles'
  'game/levels/_base'
  'text!./instructions.hbs'
  './self_view'
  './proxy_view'
  'ui_widgets/proceed'
],
(
  _
  Backbone
  Circles
  Level
  instructions
  SelfView
  Proxy
  proceed
) ->

  _degToRad = (deg) -> deg * Math.PI / 180


  View = Level.extend

    # ----------------------------------------------------- Backbone Extensions
    className: 'circleProximity'

    initialize: ->
      @listenTo @collection, 'change:interacted', @onChangeInteracted
      @listenToOnce proceed, 'click', @_close
      @distanceFromSelf = 250 # Distance from each of the circles to the self circle
      if $(window).width() < 603
        @distanceFromSelf = 200


    # ----------------------------------------------------- Rendering
    render: ->
      # Self
      @selfView = new SelfView
      @$el.html @selfView.render().el
      @selfView.position()
      # Position the line centered on self
      @$line = @$('.line')
      radius = @selfView.$el.width() / 2
      @$line.css
        left: radius
        top: radius
      # For each circle, make it a new sizey view that has a reference to the circle
      @collection.each (circle) =>
        circle.view = new Proxy
          model: circle
          $line: @$line
          selfView: @selfView
          track: _.bind @options.runner.track, @options.runner
        @$el.append circle.view.render().el
      # Calculate initial positions for each circle
      @_positionCirclesAround @selfView.getSelfCenter()
      @


    # ----------------------------------------------------- Private Methods
    _positionCirclesAround: (center) ->
      count = @collection.length
      increment = 360 / count
      deg = increment / 2 + 270
      distance = @distanceFromSelf
      @collection.each (circle) ->
        circle.view.positionByCenter
          x: Math.cos( _degToRad(deg) ) * distance + center.x
          y: Math.sin( _degToRad(deg) ) * distance + center.y
        deg += increment

    _close: ->
      @collection.each (circle) -> circle.view.remove() # Removing one at a time lets views clean up their events
      proceed.hide()
      @trigger 'done'
      @remove()


    # ----------------------------------------------------- Event Handlers
    onChangeInteracted: -> proceed.show() if @checkAllInteracted @collection



  View

