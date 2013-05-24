define [
  'backbone'
  'Handlebars'
  'core'
  'models/assessment'
  'assessments/start_view'
  'messages/error_modal_view'
  'controllers/stages_controller'
], (
  Backbone
  Handlebars
  app
  Assessment
  StartView
  ErrorModalView
  StagesController
) ->

  _me = 'pages/game'
  _defaultAssessmentId = 1

  Me = Backbone.View.extend
    className: 'gamePage'
    initialize: ->
      console.log "#{_me}.initialize()"
      # Always create a user, initially as a guest if someone is not already loggedin
      app.session.loginAsGuest()
        .done =>
          @_createAndShowAssessment(_defaultAssessmentId)
        .fail =>
          # This is a catastrophic fail of the API server, it is probably down.
          throw new Error 'session.loginAsGuest().fail()'
          errorView = new ErrorModalView
            title: "Login Error"
            message: "Cannot log in to the server, server may be down."
          errorView.display()
    render: (content) ->
      markup = content || ''
      console.log "#{_me}.render(#{markup})"
      @$el.html markup
      @

    _createAndShowAssessment: (definitionId) ->
      console.log "#{_me}._createAndShowAssessment()"
      # Create an anonymous assessment on the server with the definitionId
      if app.session.assessment?
        @_displayAssessment()
      else
        assessment = new Assessment()
        assessment.create(definitionId)
          .done =>
            app.session.assessment = assessment
            @_displayAssessment()
          .fail =>
            throw new Error("Something went wrong, can't create assessment")
      @

    _displayAssessment: ->
      console.log "#{_me}._displayAssessment()"
      # TODO: change so that the listenTo can be set up when `this` is initialized
      @listenTo app.session.assessment, 'change:stage_completed', @_stageCompleted
      #@listenTo(app.session.assessment, 'stage_completed_success', @_stageCompletedSuccess)
      view = new StartView
        model: app.session.assessment
      @render view.render().el

    _showLevel: (stageId) ->
      console.log "#{_me}._showLevel(#{stageId})"
      # TODO: briefer null check syntax
      if not @controller?
        @controller = new StagesController
          assessment: app.session.assessment
      @controller.render(stageId)
      @render @controller.el

    _stageCompleted: ->
      # Initially no stages completed, so start with -1
      @currentStageNo = app.session.assessment.get('stage_completed')
      @numOfStages = app.session.assessment.get('stages').length
      if @currentStageNo < @numOfStages
        @_showLevel @currentStageNo
      else if @currentStageNo is @numOfStages
        console.log 'Waiting the final completed request to be sent.'
      else
        throw new Error "Error with stage #{@currentStageNo}"

  Me

