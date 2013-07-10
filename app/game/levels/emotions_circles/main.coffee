define [
  'underscore'
  'backbone'
  'game/levels/_base'
  'entities/circles'
  'game/levels/circle_proximity'
],
(
  _
  Backbone
  Level
  Circles
  CircleProximity
) ->

  _me = 'game/levels/emotions_circles'


  View = Level.extend

    # ----------------------------------------------------- Backbone Extensions
    className: 'emotionsCircles'

    start: ->
#      console.log model:@model.attributes
      @collection = new Circles @model.attributes.circles
      @collection.each (model) -> model.set 'size', 4 # Emotions circles all start at the largest size
      @track Level.EVENTS.start,
        circles: @collection.toJSON()

    render: ->
      @circleProximity = new CircleProximity
        collection: @collection
        runner: @
        showInstructions: @options.showInstructions
      @$el.html @circleProximity.el
      setTimeout (=> @circleProximity.render() ), 1 # Render after putting in the dom since it needs to compute locations
      @listenToOnce @circleProximity, 'done', @onTestDone
      return this


    # ----------------------------------------------------- Event Handlers
    onTestDone: ->
      @track Level.EVENTS.end,
        circles: @collection.toJSON()
        self_coord:
          top: @circleProximity.selfView.getSelfCenter().y - @circleProximity.selfView.getSelfRadius()
          left: @circleProximity.selfView.getSelfCenter().x - @circleProximity.selfView.getSelfRadius()
          size: @circleProximity.selfView.getSelfRadius() * 2
      @remove()
      @options.assessment.nextStage()


  View

