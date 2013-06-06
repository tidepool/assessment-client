define [
  'backbone'
  'Handlebars'
  'core'
  'composite_views/perch'
  'models/assessment'
  'messages/error_modal_view'
  'modelsAndCollections/levels'
  'ui_widgets/steps_remaining'
  'stages/reaction_time'
  'stages/image_rank'
  'stages/circles_test'
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

  _me = 'pages/game'
  _defaultGame = 1
  _stepsRemainingContainer = '#HeaderRegion'
  _views =
    'ReactionTime': 'ReactionTime'
    'ImageRank': 'ImageRank'
    'CirclesTest': 'CirclesTest'

  Me = Backbone.View.extend
    className: 'gamePage'


    # ------------------------------------------------------------- Backbone Methods
    initialize: ->
      console.log "#{_me}.initialize()"
      @curGame = app.user.createAssessment()
      @_register_events()


      # if app.user.isLoggedIn()
      #   @curGame = @_createGame _defaultGame
      #   @_register_events()
      # else
      #   app.session.logInAsGuest()
      #   .done =>
      #     @curGame = @_createGame _defaultGame
      #     @_register_events()
      #   .fail =>
      #     console.log("Failed!")
      #@listenTo @curGame, 'all', (e) -> console.log "#{_me}.curGame event: #{e}"


    # ------------------------------------------------------------- Helper Methods
    _register_events: ->
      @listenTo @curGame, 'error', @_curGameErr
      @listenTo @curGame, 'change:stage_completed', @_onStageChanged


    # _createGame: (id) ->
    #   console.log "#{_me}._createGame()"
    #   game = new Assessment()
    #   game.create(id)

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
    _onStageChanged: (model) ->
      console.log "#{_me}._onStageChanged()"
      curStage = model.attributes.stage_completed
      stageCount = model.attributes.stages.length
      # Mark the changed level complete
      @levels?.setComplete curStage
      # Show the next stage
      if curStage is -1 then @_showWelcome model
      else if curStage < stageCount then @_showLevel curStage
      else console.log "#{_me}._curGameSync: unusual curStage: #{curStage}"

    _curGameErr: ->
      console.log "#{_me}._curGameErr()"
      throw new Error("Something went wrong, can't create assessment")


    # ------------------------------------------------------------- Stage Management
    _showLevel: (stageId) ->
      console.log "#{_me}._showLevel(#{stageId})"
      curStage = @curGame.get('stages')[stageId]
      viewClassString = _views[curStage.view_name]
      ViewClass = eval(viewClassString)
      stageView = new ViewClass
        model: new Backbone.Model(curStage)
        assessment: @curGame
        stageNo: stageId
      @$el.html stageView.render().el



  Me

