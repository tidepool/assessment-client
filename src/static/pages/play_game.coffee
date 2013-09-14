define [
  'backbone'
  'Handlebars'
  'core'
  'ui_widgets/steps_remaining'
  'ui_widgets/hold_please'
  'ui_widgets/psst'
  'entities/user_event/event_log'
  # Levels
  'game/levels/reaction_time_disc'
  'game/levels/circle_size_and_proximity'
  'game/levels/alex_trebek'
  'game/levels/snoozer'
  'game/levels/interest_picker'
  # Welcome Pages
  'text!game/welcome/personality.hbs'
  # Other
  'game/calculate_results'
  'game/mini_instructions'
  'utils/numbers'
  'entities/daddy_ios'
], (
  Backbone
  Handlebars
  app
  StepsRemainingView
  holdPlease
  psst
  EventLog
  # Levels
  ReactionTime
  CirclesTest
  AlexTrebek
  Snoozer
  InterestPicker
  # Welcome Pages
  tmplWelcomePersonality
  # Other
  CalculateResultsView
  MiniInstructions
  numbers
  ios
) ->

  _me = 'pages/playGame'
  _parentPageName = '/pages/play_game'
  _headerRegionSel = '#HeaderRegion'
  _coreGame = 'baseline'
  _surveyOdds = 0.25 # percent chance to show the end of game survey
  _loadTimeout = 10 * 1000 # After this long waiting, the game has failed to load and should time out
  _views =
    ReactionTime: ReactionTime
    CirclesTest: CirclesTest
    Survey: AlexTrebek
    Snoozer: Snoozer
    InterestPicker: InterestPicker
  _gameWelcomePages =
    baseline: tmplWelcomePersonality
  _titleByGameType =
    baseline: 'The Personality Game'
    emotions: 'Emotions Game'
  _defaultTitle = 'Play a Game'

  Me = Backbone.View.extend
    title: _defaultTitle
    className: 'playGamePage'
    events:
      'click #ActionBeginGame': '_begin'
      'click #WelcomeImage':    '_begin'

    initialize: ->
      throw new Error "Need params" unless @options.params
      holdPlease.show null, true # (null = no selector, true = show a random message)
      # Game
      @model = app.user.createGame @options.params.def_id
      @listenTo app.user, 'error', @_userModelErr
      @listenTo @model, 'error', @_curGameErr
      @listenTo @model, 'sync', @onSync
      @listenTo @model, 'change:stage_completed', @_onStageChanged
      @loadTimeoutPointer = setTimeout (=> @_onGameTimeout()), _loadTimeout
      app.analytics.track @className, "#{@options.params.def_id} Game Started"
      if @options.params.def_id is _coreGame
        app.analytics.trackKeyMetric "#{_coreGame} game", 'Started'


    # ------------------------------------------------------------- Helper Methods
    _showWelcome: ->
      @eventLog = new EventLog game_id:@model.attributes.id
      ios.start()
      ios.log 'Game Started'
      gameDef = @options.params.def_id
      # Decide whether to show game introduction instructions
      if _gameWelcomePages[gameDef]?
        @$el.html _gameWelcomePages[gameDef]
      else
        @_begin()

    _begin: ->
      @_trackLevels()
      @miniInstructions = new MiniInstructions
      $(_headerRegionSel).append @miniInstructions.el
      @model.nextStage()

    _showError: (msg) ->
      holdPlease.hide()
      psst
        title: 'Error'
        msg: msg
        sel: @$el
        type: psst.TYPES.error
      ios.error msg
      throw new Error "#{_me}: #{msg}"


    # ------------------------------------------------------------- Event Handlers
    onSync: -> holdPlease.hide()
    _onStageChanged: (model, stage) ->
      clearTimeout @loadTimeoutPointer
      curStage = model.attributes.stage_completed
      stageCount = model.attributes.stages.length
      @stepsRemaining?.setComplete curStage
      # Show the next stage
      if curStage is -1 then @_showWelcome()
      else if curStage < stageCount then @_showLevel curStage
      else if curStage is stageCount then @_endGame()
      else if curStage > stageCount then @_calculateResults()
      else console.warn "#{_me}._curGameSync: unusual curStage: #{curStage}"

    _curGameErr: (model, xhr) ->
      clearTimeout @loadTimeoutPointer
      console.log model:model, xhr:xhr
      msg = xhr.responseJSON?.status.message || 'Sorry, there was a problem loading the game.'
      @_showError msg

    _userModelErr: (model, xhr) ->
      clearTimeout @loadTimeoutPointer
      msg = xhr.responseJSON?.status.message || 'Sorry, there was a problem loading the user.'
      @_showError msg

    _onGameTimeout: ->
      @_showError 'Sorry, it looks like there is a problem. The game is taking too long to load.'


    # ------------------------------------------------------------- Game and Level Management
    _trackLevels: ->
      return if @model.attributes.stages.length is 1
      @stepsRemaining = new StepsRemainingView
        title: _titleByGameType[@options.params.def_id]
        collection: new Backbone.Collection @model.attributes.stages
      $(_headerRegionSel).append @stepsRemaining.render().el

    _finishPreviousLevel: (levelView) ->
      if levelView and levelView instanceof Backbone.View
        @eventLog.addEvent levelView.event if levelView.event?
        levelView.remove() #remove the existing level if it exits. This is a safety valve for leaking dom nodes and events
        @miniInstructions.model.set text:''
        app.analytics.track @className, "#{levelView.model.attributes.level_definition_name || levelView.model.attributes.view_name} Level Finished"

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
      @curLevel.trigger 'domInsert'
      app.view.scrollToTop()
      @model.setLevelSeen stageData.view_name
      app.analytics.trackPage "#{_parentPageName}/#{@options.params.def_id}/#{stageId}"
      app.analytics.track @className, "#{stageData.view_name} Level Started"
      ios.log "Game showLevel: #{stageId}"


    # ------------------------------------------------------------- End Game
    _endGame: ->
      @_finishPreviousLevel @curLevel
      # Sometimes, ask the user if they've enjoyed themselves
      if numbers.casino _surveyOdds
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
                { icon: 'gfx-happiness', value: 'yes', label:'Yes' }
                { icon: 'gfx-sadness', value: 'no', label:'No' }
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
      @curLevel = new CalculateResultsView
        game: @model
        eventLog: @eventLog
      @$el.html @curLevel.render().el
      app.analytics.trackKeyMetric "Game", "Finished"
      app.analytics.track @className, "#{@options.params.def_id} Game Finished"
      if @options.params.def_id is _coreGame
        app.analytics.trackKeyMetric "#{_coreGame} Game", 'Finished'


    # ------------------------------------------------------------- Consumable API
    # Called by the parent view.
    # Allows for cleaning up events, and external views like lightboxes and proceed controls
    close: ->
      @curLevel?.close?()
      @curLevel?.remove()


  Me

