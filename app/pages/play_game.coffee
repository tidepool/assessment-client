define [
  'backbone'
  'Handlebars'
  'core'
  'composite_views/perch'
  'entities/results_calculator'
  'entities/user_event/_event_bundle'
  'ui_widgets/steps_remaining'
  'ui_widgets/hold_please'
  'game/levels/reaction_time_disc'
  'game/levels/rank_images'
  'game/levels/circle_size_and_proximity'
  'game/levels/alex_trebek'
  'game/levels/emotions_circles'
  'game/levels/snoozer'
  'game/levels/interest_picker'
  'game/calculate_results'
  'game/mini_instructions'
  'utils/numbers'
], (
  Backbone
  Handlebars
  app
  perch
  Results
  EventBundle
  StepsRemainingView
  holdPlease
  ReactionTime
  ImageRank
  CirclesTest
  AlexTrebek
  EmotionsCircles
  Snoozer
  InterestPicker
  CalculateResultsView
  MiniInstructions
  numbers
) ->

  _me = 'pages/playGame'
  _parentPageName = '/pages/play_game'
  _headerRegionSel = '#HeaderRegion'
  _coreGame = 'baseline'
  _surveyOdds = 0.25 # % chance to show the end of game survey
  _views =
    ReactionTime: ReactionTime
    ImageRank: ImageRank
    CirclesTest: CirclesTest
    Survey: AlexTrebek
    EmotionsCircles: EmotionsCircles
    Snoozer: Snoozer
    InterestPicker: InterestPicker
  _titleByGameType =
    baseline: 'The Personality Game'
    emotions: 'Emotions Game'
#    reaction_time: 'Reaction Time'
  _defaultTitle = 'Play a Game'
  _animationTime = 1
  _gameStartMsg = 'This short, fun, and interactive assessment helps you discover your personality type.'

  Me = Backbone.View.extend
    title: _defaultTitle
    className: 'playGamePage'

    initialize: ->
      throw new Error "Need params" unless @options.params
      holdPlease.show null, true # (no selector, show a message)
      @model = app.user.createGame @options.params.def_id
      @listenTo @model, 'error', @_curGameErr
      @listenTo @model, 'sync', @onSync
      @listenTo @model, 'change:stage_completed', @_onStageChanged
      app.analytics.track @className, "#{@options.params.def_id} Game Started"
      if @options.params.def_id is _coreGame
        app.analytics.trackKeyMetric "#{_coreGame} game", 'Started'


    # ------------------------------------------------------------- Helper Methods
#    _setTitle: ->
#      title = _titleByGameType[@options.params.def_id]
#      document.title = if title then title else _defaultTitle

    _showWelcome: ->
      @_trackLevels()
      @miniInstructions = new MiniInstructions
      $(_headerRegionSel).append @miniInstructions.el
      # Decide whether to show game introduction instructions
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
    onSync: -> holdPlease.hide()
    _onStageChanged: (model, stage) ->
      #console.log "#{_me}._onStageChanged(model, #{stage})"
      curStage = model.attributes.stage_completed #+ 5 # Increment is for testing only to skip to the level you're working on
      stageCount = model.attributes.stages.length
      @stepsRemaining?.setComplete curStage
      # Show the next stage
      if curStage is -1 then @_showWelcome()
      else if curStage < stageCount then @_showLevel curStage
      else if curStage is stageCount then @_endGame()
      else if curStage > stageCount then @_calculateResults()
      else console.log "#{_me}._curGameSync: unusual curStage: #{curStage}"

    _curGameErr: ->
      console.error "#{_me}: Error on the curGame model"


    # ------------------------------------------------------------- Game and Level Management
    _trackLevels: ->
      return if @model.attributes.stages.length is 1
      @stepsRemaining = new StepsRemainingView
        title: _titleByGameType[@options.params.def_id]
        collection: new Backbone.Collection @model.attributes.stages
      $(_headerRegionSel).append @stepsRemaining.render().el

    _finishPreviousLevel: (levelView) ->
      if levelView and levelView instanceof Backbone.View
        levelView.remove() #remove the existing level if it exits. This is a safety valve for leaking dom nodes and events
        @miniInstructions.model.set text:''
        app.analytics.track @className, "#{levelView.model.attributes.stageDef} Level Finished"

    _showLevel: (stageId) ->
      #console.log "#{_me}._showLevel(#{stageId})"
      stageData = @model.get('stages')[stageId]
#      console.log stageData:stageData
      # Get the class of the level we're on. There are two possible locations for backwards compatibility.
      Level = _views[stageData.level_definition_name] || _views[stageData.view_name]
      unless Level
        throw new Error "View Class not found for game level of type #{stageData.view_name}"
      @_finishPreviousLevel @curLevel
      @curLevel = new Level
        model: new Backbone.Model(stageData)
        assessment: @model
        stageNo: stageId
        stageDef: stageData.level_definition_name || stageData.view_name
        showInstructions: stageData.view_name is 'ReactionTime' || false #@model.isFirstTimeSeeingLevel stageData.view_name
        instructions: @miniInstructions.model
      @$el.html @curLevel.render().el
      @model.setLevelSeen stageData.view_name
      app.analytics.trackPage "#{_parentPageName}/#{@options.params.def_id}/#{stageId}"
      app.analytics.track @className, "#{@curLevel.model.attributes.stageDef} Level Started"


    # ------------------------------------------------------------- End Game
    _endGame: ->
      # Sometimes, ask the user if they've enjoyed themselves
      if true # numbers.casino _surveyOdds
        @_finishPreviousLevel @curLevel
        @curLevel = new AlexTrebek
          assessment: @model
          stageNo: 999
          stageDef: 'survey'
          model: new Backbone.Model
            data: [
              question: "Did you enjoy playing this game?"
              question_id: "enjoyed_game"
              topic: "user_behavior_survey"
              question_type: "select_by_icon"
              options: [
                { icon: 'gfx-happiness', value: 'yes' }
                { icon: 'gfx-sadness', value: 'no' }
              ]
            ]
        @$el.html @curLevel.render().el
        app.analytics.trackKeyMetric "#{@options.params.def_id} Enjoyment", 'Shown Question'
        @listenToOnce @curLevel, 'done', (data) ->
          if data?.data[0]?.answer is 'yes'
            app.analytics.trackKeyMetric "#{@options.params.def_id} Enjoyment", 'Answered Yes'
          else
            app.analytics.track "#{@options.params.def_id} Enjoyment", 'Answered No'
      # Most times just calculate the results
      else
        @_calculateResults()

    _calculateResults: ->
      app.analytics.trackKeyMetric "Game", "Finished"
      app.analytics.track @className, "#{@options.params.def_id} Game Finished"
      if @options.params.def_id is _coreGame
        app.analytics.trackKeyMetric "#{_coreGame} Game", 'Finished'
      # Don't start the results calculation until we get a successful response on the user event
      @listenToOnce @curLevel.event, 'sync', (eventModel,resp,jqXHR) ->
        console.log
          eventModel:eventModel
          resp:resp
        @_finishPreviousLevel @curLevel
        @curLevel = new CalculateResultsView
          game: @model
          model: new Results
            game_id: @model.get 'id'
        @$el.html @curLevel.render().el
      # Clean up the last level



    # ------------------------------------------------------------- Consumable API
    # Called by the parent view.
    # Allows for cleaning up events, and external views like lightboxes and proceed controls
    close: ->
      @curLevel?.close?()
      @curLevel?.remove()





  Me

