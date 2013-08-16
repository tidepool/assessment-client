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

  View = Level.extend

    # ----------------------------------------------------- Backbone Extensions
    className: 'proximityTakesTurns'

    initialize: ->
      @listenTo @collection, 'change:interacted', @onChangeInteracted
      @listenToOnce proceed, 'click', @_finish
      console.log collection:@collection.toJSON()
      @once 'domInsert', @fillHeight

    render: ->
      @$el.html tmpl
      @$el.append (new Billboard).render().el
      @selfView = new SelfView
      @$(_selfContentSel).append @selfView.render().el
      @_renderCircles()
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

    _finish: ->
      @collection.each (model) -> model.view.remove() # Removing one at a time lets views clean up their events
      proceed.hide()
      @trigger 'done'
      @remove()


    # ----------------------------------------------------- UI Events

    # ----------------------------------------------------- Data Events
    onChangeInteracted: ->
      proceed.show() if @checkAllInteracted @collection





  View




