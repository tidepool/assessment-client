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
  CalculateResultsView
) ->

  _me = 'pages/playGame'
  _defaultGame = 1
  _stepsRemainingContainer = '#HeaderRegion'
  _views =
    'ReactionTime': 'ReactionTime'
    'ImageRank': 'ImageRank'
    'CirclesTest': 'CirclesTest'

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
        msg: assessmentModel.attributes.definition.instructions
        btn1Text: 'Start'
        onClose: _.bind(@curGame.nextStage, @curGame)
        mustUseButton: true


    # ------------------------------------------------------------- Event Handlers
    _onGameSync: -> #console.log "#{_me}._onGameSync()"

    _onStageChanged: (model, stage) ->
      #console.log "#{_me}._onStageChanged(model, #{stage})"
      curStage = model.attributes.stage_completed + 6 # TODO: remove increment. It's for testing only to skip to the level you're working on
      stageCount = model.attributes.stages.length
      # Mark the changed level complete
      @levels?.setComplete curStage
      # Show the next stage
      if curStage is -1 then @_showWelcome model
      else if curStage < stageCount then @_showLevel curStage
      else if curStage is stageCount then @_calculateResults model
      else console.log "#{_me}._curGameSync: unusual curStage: #{curStage}"

    _curGameErr: ->
      console.log "#{_me}._curGameErr()"
      console.error "#{_me}: Error on the curGame model"


    # ------------------------------------------------------------- Game and Level Management
    _trackLevels: ->
      @levels = new LevelsCollection @curGame.get('stages')
      @stepsRemaining = new StepsRemainingView
        collection: @levels
      $(_stepsRemainingContainer).append @stepsRemaining.render().el

    _showLevel: (stageId) ->
      #console.log "#{_me}._showLevel(#{stageId})"
      curStage = @curGame.get('stages')[stageId]
      viewClassString = _views[curStage.view_name]
      app.analytics.track @className, "game/1/level/#{stageId}", 'levelName', viewClassString
      ViewClass = eval(viewClassString)
      @curLevel?.remove() #remove the existing level if it exits. This is a safety valve for leaking dom nodes and events
      @curLevel = new ViewClass
        model: new Backbone.Model(curStage)
        assessment: @curGame
        stageNo: stageId
      @$el.html @curLevel.render().el


    # ------------------------------------------------------------- Results
    _calculateResults: (gameModel) ->
      @curLevel = new CalculateResultsView
        model: new Results
          game_id: gameModel.get 'id'
      @$el.html @curLevel.render().el


  Me

