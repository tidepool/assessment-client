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


  Export = Level.extend

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
      @options.instructions.set text: @model.get('instructions')[0]
      @curView = new CircleSize
        collection: @circlesCollection
        runner: @
        showInstructions: @options.showInstructions
      @$el.html @curView.el
      @track Level.EVENTS.sublevelStart
      @circlesCollection = @curView.collection
      @listenToOnce @curView, 'done', @_showCircleProximity

    _showCircleProximity: ->
      @options.instructions.set text: @model.get('instructions')[1]
      @curView = new CircleProximity
        collection: @circlesCollection
        runner: @
        showInstructions: @options.showInstructions
      @$el.html @curView.el
      @curView.render() # Render after putting in the dom since it needs to compute locations
      @track Level.EVENTS.sublevelStart, data:@circlesCollection.toJSON()
      @listenToOnce @curView, 'done', @onTestDone


    # ------------------------------------------------------------- Event Handlers
    onTestDone: ->
      @summaryData =
        data: @circlesCollection.toJSON()
        self_coord:
          top: @curView.selfView.getSelfCenter().y - @curView.selfView.getSelfRadius()
          left: @curView.selfView.getSelfCenter().x - @curView.selfView.getSelfRadius()
          size: @curView.selfView.getSelfRadius() * 2
      @endLevel()


  Export