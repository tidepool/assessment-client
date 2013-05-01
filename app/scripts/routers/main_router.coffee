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
  'controllers/dashboard_controller',
  'components/progress_bar_view',
  'controllers/stages_controller',
  'controllers/summary_results_controller',
  'messages/error_modal_view'
  ], ($, Backbone, 
    SessionController, Assessment, UserEvent, User, Result, Stages, 
    LoginDialog, HeaderView, StartView, DashboardController, ProgressBarView, 
    StagesController, SummaryResultsController, ErrorModalView) ->
  MainRouter = Backbone.Router.extend
    routes:
      'assessment/:defId': 'showAssessment'
      'start': 'showStart'
      'stage/:stageNo': 'showStages'
      'result': 'showResult'
      'dashboard': 'showDashboard'
      'foo': 'showFoo'

    initialize: (options) ->
      # TODO: We need to get these in properly. Figure it out!
      @definitionId = @definitionId(options)      
      window.apiServerUrl = options["apiServer"]

      # At the beginning create the session:
      @session = new SessionController()
      @session.initialize(options)
      @listenTo(@session, 'session:login_success', @handleSuccessfulLogin)
      @listenTo(@session, 'session:login_fail', @handleFailedLogin)
      @listenTo(@session, 'session:logout_success', @handleLogout)

      header = new HeaderView({session: @session})
      $('#header').html(header.render().el)

      navigateTo = Backbone.history.fragment
      Backbone.history.fragment = ""
      @navigate(navigateTo, {trigger: true})
      # Backbone.history.fragment = ""
      # @navigate("assessment/#{@definitionId}", {trigger: true})

    showFoo: ->
      console.log("Foo")

    definitionId: (options) ->
      routeFragment = Backbone.history.fragment
      matches = routeFragment.match(/(assessment\/)([1-9]*)/)
      if matches? and matches.length is 3 and matches[1] is 'assessment/'
        return parseInt(matches[2])
      else
        return options["definition"]

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

    showAssessment: ->
      # Always create a user, initially as a guest if someone is not already loggedin
      @session.loginAsGuest()
      .done =>
        console.log("Logged in as guest")
        @navigate('start', {trigger: true})
      .fail =>
        # This is a catastrophic fail of the API server, it is probably down.
        # Let them retry?
        console.log("Login not successful")  
        errorView = new ErrorModalView({title: "Login Error", message: "Cannot login to the server, server may be down."})
        errorView.display()  

        # navigateTo = Backbone.history.fragment
        # Backbone.history.fragment = ""
        # @navigate(navigateTo, {trigger: true})

    showStart: ->
      console.log('Show Start')
      # Create an anonymous assessment on the server with the definitionId
      if @session.loggedIn()
        assessment = new Assessment()
        assessment.create(@definitionId)
        .done =>
          @session.assessment = assessment
          @listenTo(@session.assessment, 'change:stage_completed', @stageCompleted)
          @listenTo(@session.assessment, 'stage_completed_success', @stageCompletedSuccess)
          view = new StartView({model: @session.assessment})
          $('#content').html(view.render().el)          
        .fail =>
          console.log("Something went wrong, can't create assessment")
          # TODO: Add some alert here

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
      if (@session.user? and @session.user.isGuest()) or not @session.user? 
        loginDialog = new LoginDialog({session: @session})
        $('#content').html(loginDialog.render().el)
      else 
        controller = new DashboardController()
        controller.initialize({session: @session})
        controller.render()

    handleSuccessfulLogin: ->
      currentLocation = Backbone.history.fragment
      locOfInterest = currentLocation.match(/[a-z]*/)[0]
      switch locOfInterest
        when 'dashboard' then newLocation = currentLocation
        when 'result' then newLocation = 'assessment'
        when 'stage' then newLocation = 'assessment'
        when 'assessment' then newLocation = 'start'
        when 'start' then newLocation = 'assessment'

      # Backbone does not naviagate if it thinks it is there anyways.
      # HACK: So change fragment to ""
      Backbone.history.fragment = ""
      @navigate(newLocation, {trigger: true})

    handleFailedLogin: ->

    handleLogout: ->
      loginDialog = new LoginDialog({session: @session})
      $('#content').html(loginDialog.render().el)



  MainRouter
