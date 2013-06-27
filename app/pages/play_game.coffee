define [
  'backbone'
  'Handlebars'
  'core'
  'composite_views/perch'
  'entities/levels'
  'entities/results_calculator'
  'ui_widgets/steps_remaining'
  'game/levels/reaction_time_disc'
  'game/levels/rank_images'
  'game/levels/circle_size_and_proximity'
  'game/levels/alex_trebek'
  'game/calculate_results'
], (
  Backbone
  Handlebars
  app
  perch
  LevelsCollection
  Results
  StepsRemainingView
  ReactionTime
  ImageRank
  CirclesTest
  AlexTrebek
  CalculateResultsView
) ->

  _me = 'pages/playGame'
  _stepsRemainingContainer = '#HeaderRegion'
  _views =
    ReactionTime: ReactionTime
    ImageRank: ImageRank
    CirclesTest: CirclesTest
    survey: AlexTrebek
  _gameStartMsg = 'This short, fun, and interactive assessment helps you discover your personality type.'

  Me = Backbone.View.extend
    className: 'playGamePage'

    initialize: ->
      @curGame = app.user.createGame()
      @_register_events()


    # ------------------------------------------------------------- Helper Methods
    _register_events: ->
      @listenTo @curGame, 'error', @_curGameErr
      @listenTo @curGame, 'sync', @_onGameSync
      @listenTo @curGame, 'change:stage_completed', @_onStageChanged

    _showWelcome: (assessmentModel) ->
      @_trackLevels()
      perch.show
        title: 'Welcome'
        msg: _gameStartMsg
        btn1Text: 'Let\'s Go'
        onClose: _.bind(@curGame.nextStage, @curGame)
        mustUseButton: true


    # ------------------------------------------------------------- Event Handlers
    _onGameSync: -> #console.log "#{_me}._onGameSync()"

    _onStageChanged: (model, stage) ->
      #console.log "#{_me}._onStageChanged(model, #{stage})"
      curStage = model.attributes.stage_completed #+ 6 # TODO: remove increment. It's for testing only to skip to the level you're working on
      stageCount = model.attributes.stages.length
      @levels?.setComplete curStage
      # Show the next stage
      if curStage is -1 then @_showWelcome model
      else if curStage < stageCount then @_showLevel curStage
      else if curStage is stageCount then @_calculateResults model
      else console.log "#{_me}._curGameSync: unusual curStage: #{curStage}"

    _curGameErr: ->
      console.error "#{_me}: Error on the curGame model"


    # ------------------------------------------------------------- Game and Level Management
    _trackLevels: ->
      @levels = new LevelsCollection @curGame.get('stages')
      @stepsRemaining = new StepsRemainingView
        collection: @levels
      $(_stepsRemainingContainer).append @stepsRemaining.render().el

    _finishPreviousLevel: (levelView) ->
      if levelView and levelView instanceof Backbone.View
        levelView.remove() #remove the existing level if it exits. This is a safety valve for leaking dom nodes and events
        levelStringId = levelView.model.get 'view_name'
        app.analytics.track @className, "#{levelStringId} Finished"

    _showLevel: (stageId) ->
      #console.log "#{_me}._showLevel(#{stageId})"
      curStage = @curGame.get('stages')[stageId]
      Level = _views[curStage.view_name]
      unless Level
        throw new Error "View Class not found for game level of type #{curStage.view_name}"
      @_finishPreviousLevel @curLevel
      @curLevel = new Level
        model: new Backbone.Model(curStage)
        assessment: @curGame
        stageNo: stageId
        showInstructions: @curGame.isFirstTimeSeeingLevel curStage.view_name
      @$el.html @curLevel.render().el
      @curGame.setLevelSeen curStage.view_name
      app.analytics.track @className, "game/1/level/#{stageId}", 'levelName', curStage.view_name
      app.analytics.track @className, "#{curStage.view_name} Started"


    # ------------------------------------------------------------- Results
    _calculateResults: (gameModel) ->
      @curLevel = new CalculateResultsView
        model: new Results
          game_id: gameModel.get 'id'
      @$el.html @curLevel.render().el


  Me

