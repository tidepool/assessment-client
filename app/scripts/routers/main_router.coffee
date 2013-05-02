define [
  'jquery',
  'Backbone',
  'controllers/session_controller', 
  'models/assessment',
  'models/user_event',
  'models/user',
  'models/result',
  'collections/stages',
  'user/login_dialog',
  'assessments/header_view',
  'assessments/start_view',
  'home/home_page_view',
  'controllers/dashboard_controller',
  'components/progress_bar_view',
  'controllers/stages_controller',
  'controllers/summary_results_controller',
  'messages/error_modal_view'
  ], ($, Backbone, 
    SessionController, Assessment, UserEvent, User, Result, Stages, 
    LoginDialog, HeaderView, StartView, HomePageView, DashboardController, ProgressBarView, 
    StagesController, SummaryResultsController, ErrorModalView) ->
  MainRouter = Backbone.Router.extend
    routes:
      '': 'showHome'
      'assessment/:defId': 'showAssessment'
      'stage/:stageNo': 'showStages'
      'result': 'showResult'
      'dashboard': 'showDashboard'

    initialize: (options) ->
      @definitionId = options["definition"]    
      window.apiServerUrl = options["apiServer"]

      # At the beginning create the session:
      @session = new SessionController()
      @session.initialize(options)
      @listenTo(@session, 'session:login_success', @handleSuccessfulLogin)
      @listenTo(@session, 'session:login_fail', @handleFailedLogin)
      @listenTo(@session, 'session:logout_success', @handleLogout)

      header = new HeaderView({session: @session})
      $('#header').html(header.render().el)
      @listenTo(header, 'command:login', @loginCommand)
      @listenTo(header, 'command:logout', @logoutCommand)
      @listenTo(header, 'command:profile', @profileCommand)

      navigateTo = Backbone.history.fragment
      Backbone.history.fragment = "zzz"
      @navigate(navigateTo, {trigger: true})
      # Backbone.history.fragment = ""
      # @navigate("assessment/#{@definitionId}", {trigger: true})

    stageCompleted: ->
      # Initially no stages completed, so start with -1
      @currentStageNo = @session.assessment.get('stage_completed')
      @numOfStages = @session.assessment.get('stages').length
      switch 
        # when @currentStageNo is -1 then @navigate('start', {trigger: true})
        when @currentStageNo < @numOfStages then @navigate("stage/#{@currentStageNo}", {trigger: true})
        when @currentStageNo is @numOfStages then console.log("Waiting the final completed request to be sent.")
        else alert("Error in stages #{@currentStageNo}!")

    stageCompletedSuccess: ->
      # TODO: This is not ideal, but we need to first send the request to server, 
      # before logging the (guest) user out. That's why I added this here.
      @currentStageNo = @session.assessment.get('stage_completed')
      @numOfStages = @session.assessment.get('stages').length
      if @currentStageNo is @numOfStages
        @navigate("result", {trigger: true})

    showHome: ->
      console.log("Show Home")
      if @session.loggedIn() and not @session.user?
        @session.loginAsCurrent()

      view = new HomePageView()
      $('#content').html(view.render().el)

    showAssessment: ->
      console.log("Show Assessment")
      @definitionId = @parseDefinitionId()
      # Always create a user, initially as a guest if someone is not already loggedin
      @session.loginAsGuest()
      .done =>
        console.log("Logged in")
        @createAndShowAssessment(@definitionId)
      .fail =>
        # This is a catastrophic fail of the API server, it is probably down.
        # Let them retry?
        console.log("Login not successful")  
        errorView = new ErrorModalView({title: "Login Error", message: "Cannot login to the server, server may be down."})
        errorView.display()  

    parseDefinitionId: ->
      routeFragment = Backbone.history.fragment
      matches = routeFragment.match(/(assessment\/)([1-9]*)/)
      if matches? and matches.length is 3 and matches[1] is 'assessment/'
        return parseInt(matches[2])
      else
        return @definitionId

    createAndShowAssessment: (definitionId) ->
      console.log('Showing Assessment')
      # Create an anonymous assessment on the server with the definitionId
      if @session.assessment?
        @displayAssessment()
      else
        assessment = new Assessment()
        assessment.create(definitionId)
        .done =>
          @session.assessment = assessment
          @displayAssessment()
        .fail =>
          console.log("Something went wrong, can't create assessment")
          # TODO: Add some alert here

    displayAssessment: ->
      @listenTo(@session.assessment, 'change:stage_completed', @stageCompleted)
      @listenTo(@session.assessment, 'stage_completed_success', @stageCompletedSuccess)
      view = new StartView({model: @session.assessment})
      $('#content').html(view.render().el)          

    showStages: ->
      console.log("Show Stage ##{@currentStageNo}")
      if not @session.assessment? or not @currentStageNo?
        @navigate('assessment', {trigger: true})

      controller = new StagesController()
      controller.initialize({assessment: @session.assessment, currentStageNo: @currentStageNo})
      controller.render()

    showResult: ->
      console.log("Show Result")
      if not @session.assessment? 
        @navigate('assessment', {trigger: true})

      controller = new SummaryResultsController()
      controller.initialize({session: @session})
      controller.render()      

    showDashboard: ->
      console.log("Showing Dashboard")
      # Only show it, if the user is not guest and is logged in
      if (@session.user? and @session.user.isGuest()) or not @session.loggedIn()
        loginDialog = new LoginDialog({session: @session})
        $('#content').html(loginDialog.render().el)
      else 
        if @session.user?
          controller = new DashboardController()
          controller.initialize({session: @session})
          controller.render()
        else 
          @session.loginAsCurrent()
          .done =>
            controller = new DashboardController()
            controller.initialize({session: @session})
            controller.render()
          .fail =>
            console.log("Something went wrong, cannot login")

    loginCommand: ->
      @loginDialog = new LoginDialog({session: @session})
      $('#content').html(loginDialog.render().el)


    handleSuccessfulLogin: ->
      if @loginDialog?
        loginDialog.close()
      
      currentLocation = Backbone.history.fragment
      locOfInterest = currentLocation.match(/[a-z]*/)[0]
      switch locOfInterest
        when 'dashboard' then newLocation = currentLocation
        when 'result' then newLocation = "assessment/#{@definitionId}"
        when 'stage' then newLocation = "assessment/#{@definitionId}"
        # when 'assessment' then newLocation = currentLocation

      # Backbone does not naviagate if it thinks it is there anyways.
      # HACK: So change fragment to ""
      Backbone.history.fragment = "zzz"
      @navigate(newLocation, {trigger: true})

    handleFailedLogin: ->

    handleLogout: ->
      # loginDialog = new LoginDialog({session: @session})
      # $('#content').html(loginDialog.render().el)
      Backbone.history.fragment = "zzz"
      @navigate('', {trigger: true})



  MainRouter
