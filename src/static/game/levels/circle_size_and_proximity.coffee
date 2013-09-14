define [
  'jquery'
  'underscore'
  'backbone'
  'Handlebars'
  'game/levels/_base'
  'entities/circles'
  'game/levels/person_fill'
  'game/levels/proximity_takes_turns'
], (
  $
  _
  Backbone
  Handlebars
  Level
  Circles
  PersonFill
  ProximityTakesTurns
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
      @curView = new PersonFill
        collection: @circlesCollection
        runner: @
        showInstructions: @options.showInstructions
      @$el.html @curView.el
      @curView.trigger 'domInsert'
      @track Level.EVENTS.sublevelStart
      @circlesCollection = @curView.collection
      @listenToOnce @curView, 'done', @_showCircleProximity

    _showCircleProximity: ->
      @curView?.close?().remove()
      @options.instructions.set text: @model.get('instructions')[1]
      @curView = new ProximityTakesTurns
        collection: @circlesCollection
        runner: @
        showInstructions: @options.showInstructions
      @$el.html @curView.el
      @curView.render() # Render after putting in the dom since it needs to compute locations
      setTimeout (=> @curView.trigger 'domInsert'), 1 # Allow the dom time to draw before declaring it inserted
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

    close: ->
      @curView?.close?().remove()
      @


  Export