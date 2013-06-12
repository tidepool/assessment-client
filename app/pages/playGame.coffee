define [
  'backbone'
  'Handlebars'
  'core'
  'composite_views/perch'
  'models/assessment'
  'messages/error_modal_view'
  'entities/levels'
  'ui_widgets/steps_remaining'
  'game/levels/reaction_time_disc'
  'game/levels/rank_images'
  'game/levels/circle_size_and_proximity'
], (
  Backbone
  Handlebars
  app
  perch
  Assessment
  ErrorModalView
  LevelsCollection
  StepsRemainingView
  ReactionTime
  ImageRank
  CirclesTest
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


    # ------------------------------------------------------------- Backbone Methods
    initialize: ->
      @curGame = app.user.createAssessment()
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

    _trackLevels: ->
      @levels = new LevelsCollection @curGame.get('stages')
      @stepsRemaining = new StepsRemainingView
        collection: @levels
      $(_stepsRemainingContainer).append @stepsRemaining.render().el


    # ------------------------------------------------------------- Event Handlers
    _onGameSync: -> #console.log "#{_me}._onGameSync()"

    _onStageChanged: (model, stage) ->
      #console.log "#{_me}._onStageChanged(model, #{stage})"
      curStage = model.attributes.stage_completed + 8 # TODO: remove increment. It's for testing only to skip to the level you're working on
      stageCount = model.attributes.stages.length
      # Mark the changed level complete
      @levels?.setComplete curStage
      # Show the next stage
      if curStage is -1 then @_showWelcome model
      else if curStage < stageCount then @_showLevel curStage
      else if curStage is stageCount then @_completeGame()
      else console.log "#{_me}._curGameSync: unusual curStage: #{curStage}"

    _curGameErr: ->
      console.log "#{_me}._curGameErr()"
      throw new Error("Something went wrong, can't create assessment")


    # ------------------------------------------------------------- Game and Level Management
    _showLevel: (stageId) ->
      #console.log "#{_me}._showLevel(#{stageId})"
      curStage = @curGame.get('stages')[stageId]
      viewClassString = _views[curStage.view_name]
      ViewClass = eval(viewClassString)
      @curLevel?.remove() #remove the existing level if it exits. This is a safety valve for leaking dom nodes and events
      @curLevel = new ViewClass
        model: new Backbone.Model(curStage)
        assessment: @curGame
        stageNo: stageId
      @$el.html @curLevel.render().el
    _completeGame: ->
      app.router.navigate 'dashboard',
        trigger: true


  Me

