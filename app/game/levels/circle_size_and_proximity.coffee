define [
  'jquery'
  'underscore'
  'backbone'
  'Handlebars'
  'game/levels/_base'
  'entities/circles'
  'game/levels/circle_size'
  'game/levels/person_fill'
  'game/levels/circle_proximity'
  'game/levels/proximity_takes_turns'
  'utils/detect'
], (
  $
  _
  Backbone
  Handlebars
  Level
  Circles
  CircleSize
  PersonFill
  CircleProximity
  ProximityTakesTurns
  detect
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
      if detect.isPhoneOrTablet()
        SizeLevel = PersonFill
      else
        SizeLevel = CircleSize
      @options.instructions.set text: @model.get('instructions')[0]
      @curView = new SizeLevel
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
      if detect.isPhoneOrTablet()
        ProxLevel = ProximityTakesTurns
      else
        ProxLevel = CircleProximity
      @options.instructions.set text: @model.get('instructions')[1]
      @curView = new ProxLevel
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