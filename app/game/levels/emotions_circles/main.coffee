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


  View = Level.extend

    # ----------------------------------------------------- Backbone Extensions
    className: 'emotionsCircles'

    start: ->
#      console.log model:@model.attributes
      @options.instructions.set text: @model.get('instructions')
      @collection = new Circles @model.attributes.circles
      @collection.each (model) -> model.set 'size', 4 # Emotions circles all start at the largest size
      @clearInteracted @collection # Since we set the size it thinks the user interacted with them. Psych!
      @track Level.EVENTS.start

    render: ->
      @circleProximity = new CircleProximity
        collection: @collection
        runner: @
        showInstructions: @options.showInstructions
      @$el.html @circleProximity.el
      setTimeout (=> @circleProximity.render() ), 1 # Render after putting in the dom since it needs to compute locations
      @listenToOnce @circleProximity, 'done', @onTestDone
      @


    # ----------------------------------------------------- Event Handlers
    onTestDone: ->
      @summaryData =
        data: @collection.toJSON()
        self_coord:
          top: @circleProximity.selfView.getSelfCenter().y - @circleProximity.selfView.getSelfRadius()
          left: @circleProximity.selfView.getSelfCenter().x - @circleProximity.selfView.getSelfRadius()
          size: @circleProximity.selfView.getSelfRadius() * 2
      @endLevel()


  View

