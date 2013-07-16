define [
  'underscore'
  'backbone'
  'entities/circles'
  'game/levels/_base'
  'text!./instructions.hbs'
  './sizey_view'
  'composite_views/perch'
  'ui_widgets/proceed'
],
(
  _
  Backbone
  Circles
  Level
  instructions
  Sizey
  perch
  proceed
) ->

  _me = 'game/levels/circle_size'
  _USEREVENTS =
    resized: 'circle_resized'

  View = Level.extend

    # ----------------------------------------------------- Backbone Extensions
    className: 'circleSize'



    initialize: ->
      @listenTo @collection, 'change:interacted', @onChangeInteracted
      @listenTo @collection, 'change:size', @onChangeSize
      @listenToOnce proceed, 'click', @_close
      _.bindAll @, 'render'

      if @options.showInstructions
        perch.show
          content: instructions
          btn1Text: "I'm Ready"
          onClose: @render
          mustUseButton: true
          supressTracking: true
      else
        @render()

    render: ->
      # For each circle, make it a new sizey view that has a reference to the circle
      @collection.each (circle) =>
        circle.view = new Sizey model: circle
        @$el.append circle.view.render().el
      @


    # ----------------------------------------------------- Private Methods
    _close: ->
      @collection.each (circle) -> circle.view?.remove?() #Close them down properly. Lets them assign widths and remove events.
      proceed.hide()
      @clearInteracted @collection
      @trigger 'done'
      @remove()


    # ----------------------------------------------------- Event Handlers
    onChangeSize: (model, size) ->
      @options.runner.track _USEREVENTS.resized,
        circle_no: model.collection.indexOf model
        new_size: size

    onChangeInteracted: -> proceed.show() if @checkAllInteracted @collection


  View


