define [
  'jquery'
  'Backbone'
  'controllers/session_controller'
  'models/assessment'
  'models/user_event'
  'models/user'
  'models/result'
  'user/login_dialog'
  'user/profile_dialog'
  'ui_widgets/header'
  'assessments/start_view'
  'home/home_page_view'
  'controllers/dashboard_controller'
  'controllers/stages_controller'
  'controllers/summary_results_controller'
  'messages/error_modal_view'
],
(
  $
  Backbone
  SessionController
  Assessment
  UserEvent
  User
  Result
  LoginDialog
  ProfileDialog
  HeaderView
  StartView
  HomePageView
  DashboardController
  StagesController
  SummaryResultsController
  ErrorModalView
) ->
  _me = 'routers/main_router'

  MainRouter = Backbone.Router.extend
    routes:
      '': 'showHome'
      'game/:defId': 'showGame'
      'result': 'showResult'
      'dashboard': 'showDashboard'

    initialize: (options) ->
      @cfg = options
      # At the beginning create the session:
      @session = new SessionController()
      @session.initialize options
      #@listenTo(@session, 'session:login_success', @_handleSuccessfulLogin)
      @listenTo(@session, 'session:login_fail', @_handleFailedLogin)
      @listenTo(@session, 'session:logout_success', @_handleLogout)

      @header = new HeaderView
        session: @session
      @listenTo(@header, 'command:login', @_loginCommand)
      @listenTo(@header, 'command:logout', @_logoutCommand)
      @listenTo(@header, 'command:profile', @_profileCommand)
      $('body').prepend(@header.el)

    # ----------------------------- Actual Route Responses
    showHome: ->
      console.log "#{_me}.showHome()"
      @header.showNav().render()
      if @session.loggedIn() and not @session.user?
        @session.loginAsCurrent()
      view = new HomePageView()
      $('#content').html(view.render().el)

    showGame: (id) ->
      console.log "#{_me}.showGame()"
      @header.hideNav().render()
      @definitionId = id || 1
      # Always create a user, initially as a guest if someone is not already loggedin
      @session.loginAsGuest()
        .done =>
          @_createAndShowAssessment(id)
        .fail =>
          # This is a catastrophic fail of the API server, it is probably down.
          # Let them retry?
          console.log("Login not successful")
          errorView = new ErrorModalView
            title: "Login Error"
            message: "Cannot log in to the server, server may be down."
          errorView.display()

    showResult: ->
      console.log "#{_me}.showResult()"
      @header.showNav().render()
      @showGame() unless @session.assessment
      controller = new SummaryResultsController()
      controller.initialize({session: @session})
      controller.render()

    showDashboard: ->
      console.log "#{_me}.showDashboard()"
      @header.showNav().render()
      # Only show it, if the user is not guest and is logged in
      if (@session.user? and @session.user.isGuest()) or not @session.loggedIn()
        loginDialog = new LoginDialog({session: @session})
        $('#content').html loginDialog.render().el
      else
        if @session.user?
          controller = new DashboardController()
          controller.initialize
            session: @session
          controller.render()
        else
          @session.loginAsCurrent()
            .done =>
              controller = new DashboardController()
              controller.initialize
                session: @session
              controller.render()
            .fail =>
              console.log("Something went wrong, cannot log in")









    # ----------------------------- Supporting Methods
    _createAndShowAssessment: (definitionId) ->
      console.log "#{_me}._createAndShowAssessment()"
      # Create an anonymous assessment on the server with the definitionId
      if @session.assessment?
        @_displayAssessment()
      else
        assessment = new Assessment()
        assessment.create(definitionId)
        .done =>
          @session.assessment = assessment
          @_displayAssessment()
        .fail =>
          throw new Error("Something went wrong, can't create assessment")

    _displayAssessment: ->
      console.log "#{_me}._displayAssessment()"
      @listenTo(@session.assessment, 'change:stage_completed', @_stageCompleted)
      #@listenTo(@session.assessment, 'stage_completed_success', @_stageCompletedSuccess)
      view = new StartView
        model: @session.assessment
      $('#content').html view.render().el

    _showLevel: (stageId) ->
      console.log "#{_me}._showLevel(#{stageId})"
      if not @controller?
        @controller = new StagesController
          assessment: @session.assessment
      @controller.render(stageId)
      $('#content').html @controller.el

    _stageCompleted: ->
          # Initially no stages completed, so start with -1
      @currentStageNo = @session.assessment.get('stage_completed')
      @numOfStages = @session.assessment.get('stages').length
      if @currentStageNo < @numOfStages
        @_showLevel @currentStageNo
      else if @currentStageNo is @numOfStages
        console.log 'Waiting the final completed request to be sent.'
      else
        throw new Error "Error with stage #{@currentStageNo}"

#    _stageCompletedSuccess: ->
#      # TODO: This is not ideal, but we need to first send the request to server,
#      # before logging the (guest) user out. That's why I added this here.
#      @currentStageNo = @session.assessment.get('stage_completed')
#      @numOfStages = @session.assessment.get('stages').length
#      if @currentStageNo is @numOfStages
#        @navigate("result", {trigger: true})

    _loginCommand: ->
      @loginDialog = new LoginDialog
        session: @session
      @loginDialog.show()

    _handleSuccessfulLogin: ->
      @loginDialog?.close()
      currentLocation = Backbone.history.fragment
      locOfInterest = currentLocation.match(/[a-z]*/)[0]
      switch locOfInterest
        when 'dashboard' then newLocation = currentLocation
        when 'result' then newLocation = "game/#{@definitionId}"
        when 'stage' then newLocation = "game/#{@definitionId}"
        # when 'assessment' then newLocation = currentLocation

      # Backbone does not naviagate if it thinks it is there anyways.
      # HACK: So change fragment to ""
      Backbone.history.fragment = "zzz"
      @navigate(newLocation, {trigger: true})

    _handleFailedLogin: ->

    
    _profileCommand: ->
      @profileDialog = new ProfileDialog({user: @session.user})
      @profileDialog.show()

    _handleLogout: ->
      @showHome()



  MainRouter
