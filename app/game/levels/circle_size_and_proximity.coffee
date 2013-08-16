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
  detect
) ->


  Export = Level.extend

    # ------------------------------------------------------------- Backbone Methods
    className: 'circleSizeAndProximity'

    start: (options) ->
      @circlesCollection = new Circles @model.get 'circles'
      @track Level.EVENTS.start
      @once 'domInsert', (=> @curView.trigger 'domInsert')

    render: ->
      @_showCircleSize()
      @


    # ------------------------------------------------------------- Running the Game Level / Stage
    _showCircleSize: ->
      if detect.isPhoneOrTablet()
        SizingLevel = PersonFill
      else
        SizingLevel = CircleSize
      @options.instructions.set text: @model.get('instructions')[0]
      @curView = new SizingLevel
        collection: @circlesCollection
        runner: @
        showInstructions: @options.showInstructions
      @$el.html @curView.el
      @track Level.EVENTS.sublevelStart
      @circlesCollection = @curView.collection
      @listenToOnce @curView, 'done', @_showCircleProximity

    _showCircleProximity: ->
      @curView?.close?().remove()
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