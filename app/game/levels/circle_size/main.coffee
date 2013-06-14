define [
  'underscore'
  'backbone'
  'entities/circles'
  'text!./instructions.hbs'
  './sizey_view'
  'composite_views/perch'
  'ui_widgets/proceed'
],
(
  _
  Backbone
  Circles
  instructions
  Sizey
  perch
  proceed
) ->

  _me = 'game/levels/circle_size'
  _userMaySkipThisMany = 0
  _USEREVENTS =
    resized: 'circle_resized'

  View = Backbone.View.extend

    # ----------------------------------------------------- Backbone Extensions
    className: 'circleSize'

    initialize: ->
      @listenTo @collection, 'change:userChangedSize', @onChangeUserChangedSize
      @listenTo @collection, 'change:size', @onChangeSize
      @listenToOnce proceed, 'click', @_close
      _.bindAll @, 'render'
      perch.show
        content: instructions
        btn1Text: "I'm Ready"
        btn1Callback: @render
        mustUseButton: true
        supressTracking: true

    render: ->
      # For each circle, make it a new sizey view that has a reference to the circle
      @collection.each (circle) =>
        circle.view = new Sizey model: circle
        @$el.append circle.view.render().el
      @


    # ----------------------------------------------------- Private Methods
    _checkDone: ->
      # Ready to proceed if the user changed all the circle sizes
      changedCircles = @collection.filter (circle) -> circle.get('userChangedSize')
      return true if changedCircles.length >= @collection.length - _userMaySkipThisMany

    _close: ->
      @collection.each (circle) -> circle.view.close() #Close them down properly. Lets them assign widths and remove events.
      proceed.hide()
      @trigger 'done'
      @remove()


    # ----------------------------------------------------- Event Handlers
    onChangeSize: (model, size) ->
      @options.runner?.track?(
        event_desc: _USEREVENTS.resized
        circle_no: model.collection.indexOf model
        new_size: size
      )
    onChangeUserChangedSize: ->
      #console.log "#{_me}.onChangeUserChangedSize()"
      proceed.show() if @_checkDone()



  View


