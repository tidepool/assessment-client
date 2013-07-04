define [
  'underscore'
  'backbone'
  'composite_views/perch'
  'ui_widgets/proceed'
  'entities/user_event'
],
(
  _
  Backbone
  perch
  proceed
  UserEvent
) ->

  _me = 'game/levels/_base'
  _EVENTS =
    start: 'test_started'
    interact: 'interacted'
    change: 'changed'
    readyToProceed: 'ready_to_proceed'
    notReadyToProceed: 'not_ready_to_proceed'
    end: 'test_completed'
  _viewNameToModuleName =
    ImageRank: 'image_rank'
    CirclesTest: 'circles_test'
    ReactionTime: 'reaction_time'
    Survey: 'survey'


  View = Backbone.View.extend

    # ----------------------------------------------------- Backbone Extensions
    initialize: ->
      unless @options.assessment? and @options.stageNo?
        throw new Error "Need assessment and stageNo"
      #      console.log "#{_me}.initialize()"
      if @model.attributes.data?
        @collection = new Backbone.Collection @model.attributes.data
      if typeof @start is "function"
        @start() # Call the mixed-in level's start method, if it has impelemented one
      else
        @track _EVENTS.start


    # ----------------------------------------------------- Private Methods
    _close: ->
      proceed.hide()
      if @finalEventData? # Track the end of the level. The level may optionally provide @finalEventData to be tracked along with it
        @track _EVENTS.end, @finalEventData
      else
        @track _EVENTS.end
      @trigger 'done'
      @close?() # Call the mixed-in level's close method, if it has implemented one
      @remove()
      @options.assessment.nextStage()


    # ------------------------------------------------------------- Consumable API
    # Check the whole collection for an `interacted` property. Return true if they all are.
    checkAllInteracted: (collection) ->
      interacted = collection.filter (item) -> item.get('interacted')
      return true if interacted.length is collection.length

    readyToProceed: ->
      return if @alreadyReady
      @alreadyReady = true
      proceed.show()
      @listenToOnce proceed, 'click', @_close
      @track _EVENTS.readyToProceed

    notReadyToProceed: ->
      return if not @alreadyReady
      @alreadyReady = false
      proceed.hide()
      @stopListening proceed
      @track _EVENTS.notReadyToProceed

    track: (eventName, event) ->
      baseData =
        event_desc: eventName
        game_id: @options.assessment.attributes.id # The game instance
        module: _viewNameToModuleName[@model.attributes.view_name] # The string id of the level type (eg: 'ImageRank')
        stage: @options.stageNo # The index of the level instance (eg: 0 is the first level in the game)
      userEvent = new UserEvent _.extend(baseData, event)
      userEvent.save()

    remove: ->
      proceed.hide()
      @$el.remove()
      @stopListening()
      return this


  View.EVENTS = _EVENTS
  View
