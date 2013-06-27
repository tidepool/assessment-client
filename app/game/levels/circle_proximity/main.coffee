define [
  'underscore'
  'backbone'
  'entities/circles'
  'text!./instructions.hbs'
  'composite_views/perch'
  './self_view'
  './proxy_view'
  'ui_widgets/proceed'
],
(
  _
  Backbone
  Circles
  instructions
  perch
  SelfView
  Proxy
  proceed
) ->

  _me = 'game/levels/circle_proximity'
  #_lineMarkup = '<div class="line"></div>'
  _USEREVENTS =
    dragStart: ''
    dragStop: ''
  _degToRad = (deg) -> deg * Math.PI / 180


  View = Backbone.View.extend

    # ----------------------------------------------------- Backbone Extensions
    className: 'circleProximity'

    initialize: ->
      @listenTo @collection, 'change:userChangedPos', @onChangeUserChangedPos
      @listenToOnce proceed, 'click', @_close

    render: ->
      #console.log "#{_me}.render()"
      if @options.showInstructions
        perch.show
          content: instructions
          btn1Text: "I'm Ready"
          large: true
          btn1Callback: _.bind @_renderLevel, @
          mustUseButton: true
          supressTracking: true
      else
        @_renderLevel()


    # ----------------------------------------------------- Private Methods
    _renderLevel: ->
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


    _positionCirclesAround: (center) ->
      count = @collection.length
      increment = 360 / count
      deg = increment / 2 + 270
      distance = 250
      @collection.each (circle) =>
        circle.view.positionByCenter
          x: Math.cos( _degToRad(deg) ) * distance + center.x
          y: Math.sin( _degToRad(deg) ) * distance + center.y
        deg += increment

    _checkDone: ->
      # Ready to proceed if the user changed all the circle sizes
      changedCircles = @collection.filter (circle) -> circle.get('userChangedPos')
      return true if changedCircles.length is @collection.length

    _close: ->
      @collection.each (circle) -> circle.view.remove() # Removing one at a time lets views clean up their events
      proceed.hide()
      @trigger 'done'
      @remove()


    # ----------------------------------------------------- Event Handlers
    onChangeUserChangedPos: ->
      proceed.show() if @_checkDone()


    # ----------------------------------------------------- Consumable API



  View

