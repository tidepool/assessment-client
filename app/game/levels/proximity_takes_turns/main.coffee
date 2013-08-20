define [
  'jquery'
  'underscore'
  'backbone'
  'entities/circles'
  'game/levels/_base'
  'text!./proximity_takes_turns.hbs'
  './billboard'
  './self_view'
  './circle_view'
  'ui_widgets/proceed'
],
(
  $
  _
  Backbone
  Circles
  Level
  tmpl
  Billboard
  SelfView
  CircleView
  proceed
) ->


  _selfContentSel = '.zoneSelf'
  _upKey = 38
  _downKey = 40


  View = Level.extend

    # ----------------------------------------------------- Backbone Extensions
    className: 'proximityTakesTurns'

    initialize: ->
      @listenTo @collection, 'change:interacted', @onChangeInteracted
      @listenTo @collection, 'change:focus', @onChangeFocus
      @listenTo @collection, 'change:selfProximityPx', @onChangeSelfProximityPx
      @listenToOnce proceed, 'click', @_finish
      @once 'domInsert', @fillHeight
      _.bindAll @, 'next', 'onKeydown'
      $(window).on 'keydown', @onKeydown

    render: ->
      @$el.html tmpl
      @billboard = new Billboard
      @$el.append @billboard.render().el
      @selfView = new SelfView
      @$(_selfContentSel).append @selfView.render().el
      @_renderCircles()
      @next()
      @


    # ----------------------------------------------------- Private Methods
    _renderCircles: ->
      # For each circle, make it a new sizey view that has a reference to the circle
      @collection.each (circle) =>
        circle.view = new CircleView
          model: circle
          selfView: @selfView
          track: _.bind @options.runner.track, @options.runner
        @$el.append circle.view.render().el
      @

    _finish: ->
      @collection.each (model) -> model.view.remove() # Removing one at a time lets views clean up their events
      proceed.hide()
      @trigger 'done'
      @remove()
      @

    # Remove the focus appearance and attribute from all circles
    _clearFocus: ->
      @collection.invoke 'set', focus:false # Set focus:false on all models in the collection
      @billboard.focusOut()

    # Focus on a single circle
    _focusCircle: (circle) ->
#      console.log "#{circle.attributes.abbreviation} focused"
      @_clearFocus()
      circle.set focus:true, {dontBubble:true}
      if circle.attributes.interacted
        @billboard.focusIn circle
      else
        @billboard.slideIn circle
      @


    # ----------------------------------------------------- UI Events
    onKeydown: (event) ->
      code = event.charCode || event.which
      curCircle = @collection.find (circle) -> circle.attributes.focus
      console.log 'keydown'
      return unless curCircle
      switch code
        when _upKey then curCircle.view.bumpUp()
        when _downKey then curCircle.view.bumpDown()
      @


    # ----------------------------------------------------- Data Events
    onChangeInteracted: ->
      @next() unless @allMoved

    onChangeFocus: (model, isFocused, options) ->
      return if options.dontBubble # prevents circular event triggering
      @_focusCircle model if isFocused

    # Recalculate the normalized distances whenever any of them change
    onChangeSelfProximityPx: ->
      # Get all the distances
      distances = @collection.pluck 'selfProximityPx'
      max = _.max distances
      ratio = max / 100
      @collection.each (model) ->
        if model.attributes.selfProximityPx?
          normalized = Math.round model.attributes.selfProximityPx / ratio
          model.set selfProximityNormalized:normalized
        else
          model.set selfProximityNormalized:null
#      console.log nrmlDistances: @collection.pluck 'selfProximityNormalized'


    # ----------------------------------------------------- Consumable API
    # Show the next circle
    next: ->
      # Get the first circle that hasn't been touched
      fresh = @collection.filter (item) -> !item.get('interacted')
      firstModel = fresh[0]
      # If there is an untouched circle, focus on it
      if firstModel
        firstModel.set focus:true
      # Otherwise allow the level to end
      else
        @allMoved = true
        @_clearFocus()
        proceed.show()
      @

    close: ->
      $(window).off 'keydown', @onKeydown
      @


  View




