define [
  'backbone'
  'Handlebars'
  'core'
  'composite_views/perch'
  'entities/results_calculator'
  'ui_widgets/steps_remaining'
  'game/levels/reaction_time_disc'
  'game/levels/rank_images'
  'game/levels/circle_size_and_proximity'
  'game/levels/alex_trebek'
  'game/levels/emotions_circles'
  'game/levels/snoozer'
  'game/calculate_results'
], (
  Backbone
  Handlebars
  app
  perch
  Results
  StepsRemainingView
  ReactionTime
  ImageRank
  CirclesTest
  AlexTrebek
  EmotionsCircles
  Snoozer
  CalculateResultsView
) ->

  _me = 'pages/playGame'
  _stepsRemainingContainer = '#HeaderRegion'
  _views =
    ReactionTime: ReactionTime
    ImageRank: ImageRank
    CirclesTest: CirclesTest
    Survey: AlexTrebek
    emotions_circles: EmotionsCircles
    Snoozer: Snoozer
#  _titleByGameType =
#    baseline: 'Core Personality Game'
#    emotions: 'The Emotions Game'
#    reaction_time: 'The Reaction Time Game'
  _defaultTitle = 'Play a Game'
  _animationTime = 1
  _raceConditionDelay = 500 #TODO: remove this. Prevents a race condition exhibited if the server starts calculating before all events are received
  _gameStartMsg = 'This short, fun, and interactive assessment helps you discover your personality type.'

  Me = Backbone.View.extend
    title: _defaultTitle
    className: 'playGamePage'

    initialize: ->
      throw new Error "Need params" unless @options.params
      @model = app.user.createGame @options.params.def_id
#      @_setTitle @options.params.def_id
      @listenTo @model, 'error', @_curGameErr
      @listenTo @model, 'change:stage_completed', @_onStageChanged


    # ------------------------------------------------------------- Helper Methods
#    _setTitle: ->
#      title = _titleByGameType[@options.params.def_id]
#      document.title = if title then title else _defaultTitle

    _showWelcome: ->
      @_trackLevels()
      if @model.attributes.definition?.instructions
        perch.show
          title: 'Welcome'
          msg: @model.attributes.definition.instructions
          btn1Text: 'Let\'s Go'
          onClose: => setTimeout _.bind(@model.nextStage, @model), _animationTime
            # This delay is needed because bootstrap's modal does not handle 2 dialogs in quick succession well.
            # Without it, the onClose event is not separately fired and the callbacks cannot behave as expected.
          mustUseButton: true
      else
        @model.nextStage()


    # ------------------------------------------------------------- Event Handlers
    _onStageChanged: (model, stage) ->
      #console.log "#{_me}._onStageChanged(model, #{stage})"
      curStage = model.attributes.stage_completed #+ 3 # Increment is for testing only to skip to the level you're working on
      stageCount = model.attributes.stages.length
      @stepsRemaining?.setComplete curStage
      # Show the next stage
      if curStage is -1 then @_showWelcome()
      else if curStage < stageCount then @_showLevel curStage
      else if curStage is stageCount then @_calculateResults model
      else console.log "#{_me}._curGameSync: unusual curStage: #{curStage}"

    _curGameErr: ->
      console.error "#{_me}: Error on the curGame model"


    # ------------------------------------------------------------- Game and Level Management
    _trackLevels: ->
      return if @model.attributes.stages.length is 1
      @stepsRemaining = new StepsRemainingView
        collection: new Backbone.Collection @model.attributes.stages
      $(_stepsRemainingContainer).append @stepsRemaining.render().el

    _finishPreviousLevel: (levelView) ->
      if levelView and levelView instanceof Backbone.View
        levelView.remove() #remove the existing level if it exits. This is a safety valve for leaking dom nodes and events
        levelStringId = levelView.model.get 'view_name'
        app.analytics.track @className, "#{levelStringId} Finished"

    _showLevel: (stageId) ->
      #console.log "#{_me}._showLevel(#{stageId})"
      curStage = @model.get('stages')[stageId]
      # Get the class of the level we're on. There are two possible locations for backwards compatibility.
      Level = _views[curStage.level_definition_name] || _views[curStage.view_name]
      unless Level
        throw new Error "View Class not found for game level of type #{curStage.view_name}"
      @_finishPreviousLevel @curLevel
      @curLevel = new Level
        model: new Backbone.Model(curStage)
        assessment: @model
        stageNo: stageId
        showInstructions: @model.isFirstTimeSeeingLevel curStage.view_name
      @$el.html @curLevel.render().el
      @model.setLevelSeen curStage.view_name
      app.analytics.track @className, "game/1/level/#{stageId}", 'levelName', curStage.view_name
      app.analytics.track @className, "#{curStage.view_name} Started"


    # ------------------------------------------------------------- Results
    _calculateResults: (gameModel) ->
      setTimeout (=>
        @curLevel = new CalculateResultsView
          game: gameModel
          model: new Results
            game_id: gameModel.get 'id'
        @$el.html @curLevel.render().el
      ), _raceConditionDelay


    # ------------------------------------------------------------- Consumable API
    # Called by the parent view.
    # Allows for cleaning up events, and external views like lightboxes and proceed controls
    close: ->
      @curLevel?.close?()
      @curLevel?.remove()



  Me

