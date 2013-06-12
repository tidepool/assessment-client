define [
  'jquery'
  'underscore'
  'backbone'
  'Handlebars'
  'models/user_event'
  'entities/circles'
  'game/levels/circle_size'
  'game/levels/circle_proximity'
], (
  $
  _
  Backbone
  Handlebars
  UserEvent
  Circles
  CircleSize
  CircleProximity
) ->

  _me = 'game/levels/circle_size_and_proximity'
  _researchModuleName = 'circles_test'
  _USEREVENTS =
    started: 'test_started'
    startedSizing: 'size_circles_started'
    startedProximity: 'move_circles_started'
    completed: 'test_completed'

  View = Backbone.View.extend

    # ------------------------------------------------------------- Backbone Methods
    className: 'circleSizeAndProximity'
    initialize: (options) ->
      @track event_desc: _USEREVENTS.started
      @circlesCollection = new Circles @model.get 'circles'
      _.bindAll @, 'track'

    render: ->
      @_showCircleSize()
      @


    # ------------------------------------------------------------- Running the Game Level / Stage
    _showCircleSize: ->
      @curView = new CircleSize
        collection: @circlesCollection
        runner: @
      @$el.html @curView.el
      @track event_desc: _USEREVENTS.startedSizing
      @circlesCollection = @curView.collection
      @listenToOnce @curView, 'done', @_showCircleProximity

    _showCircleProximity: ->
      @curView = new CircleProximity
        collection: @circlesCollection
        runner: @
      @$el.html @curView.el
      @track
        event_desc: _USEREVENTS.startedProximity
        circles: @circlesCollection.toJSON()
      @listenToOnce @curView, 'done', @onTestDone


    # ------------------------------------------------------------- Event Handlers
    onTestDone: ->
      @remove()
      @track
        event_desc: _USEREVENTS.completed
        circles: @circlesCollection.toJSON()
        self_coord:
          top: @curView.selfView.getSelfCenter().y - @curView.selfView.getSelfRadius()
          left: @curView.selfView.getSelfCenter().x - @curView.selfView.getSelfRadius()
          size: @curView.selfView.getSelfRadius() * 2
      @options.assessment.nextStage()


    # ------------------------------------------------------------- Consumable API
    track: (newEvent) ->
      eventInfo =
        game_id: @options.assessment.get('id')
        module: _researchModuleName
        stage: @options.stageNo
      userEvent = new UserEvent()
      userEvent.send _.extend(eventInfo, newEvent)


  View