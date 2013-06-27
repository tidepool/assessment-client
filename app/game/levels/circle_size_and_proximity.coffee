define [
  'jquery'
  'underscore'
  'backbone'
  'Handlebars'
  'game/levels/_base'
  'entities/circles'
  'game/levels/circle_size'
  'game/levels/circle_proximity'
], (
  $
  _
  Backbone
  Handlebars
  Level
  Circles
  CircleSize
  CircleProximity
) ->

  _me = 'game/levels/circle_size_and_proximity'
  _EVENTS =
    startedSizing: 'size_circles_started'
    startedProximity: 'move_circles_started'

  View = Level.extend

    # ------------------------------------------------------------- Backbone Methods
    className: 'circleSizeAndProximity'

    start: (options) ->
      @circlesCollection = new Circles @model.get 'circles'
      @track Level.EVENTS.start

    render: ->
      @_showCircleSize()
      @


    # ------------------------------------------------------------- Running the Game Level / Stage
    _showCircleSize: ->
      @curView = new CircleSize
        collection: @circlesCollection
        runner: @
        showInstructions: @options.showInstructions
      @$el.html @curView.el
      @track _EVENTS.startedSizing
      @circlesCollection = @curView.collection
      @listenToOnce @curView, 'done', @_showCircleProximity

    _showCircleProximity: ->
      @curView = new CircleProximity
        collection: @circlesCollection
        runner: @
        showInstructions: @options.showInstructions
      @$el.html @curView.el
      @curView.render() # Render after putting in the dom since it needs to compute locations
      @track _EVENTS.startedProximity,
        circles: @circlesCollection.toJSON()
      @listenToOnce @curView, 'done', @onTestDone


    # ------------------------------------------------------------- Event Handlers
    onTestDone: ->
      @remove()
      @track Level.EVENTS.end,
        circles: @circlesCollection.toJSON()
        self_coord:
          top: @curView.selfView.getSelfCenter().y - @curView.selfView.getSelfRadius()
          left: @curView.selfView.getSelfCenter().x - @curView.selfView.getSelfRadius()
          size: @curView.selfView.getSelfRadius() * 2
      @options.assessment.nextStage()


    # ------------------------------------------------------------- Consumable API
    close: ->



  View