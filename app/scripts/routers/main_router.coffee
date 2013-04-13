define [
  'jquery',
  'Backbone',
  'models/session', 
  'models/assessment',
  'models/user_event',
  'models/user',
  'models/result',
  'collections/stages',
  'assessments/login_dialog',
  'assessments/header_view',
  'assessments/start_view',
  'dashboard/dashboard_main_view',
  'components/progress_bar_view',
  'controllers/stages_controller',
  'controllers/summary_results_controller'
  ], ($, Backbone, 
    Session, Assessment, UserEvent, User, Result, Stages, 
    LoginDialog, HeaderView, StartView, DashboardMainView, ProgressBarView, 
    StagesController, SummaryResultsController) ->
  MainRouter = Backbone.Router.extend
    routes:
      'start': 'showStart'
      'stage/:stageNo': 'showStages'
      'result': 'showResult'
      'login': 'showLogin'
      'dashboard': 'showDashboard'

    initialize: (options) ->
      @eventDispatcher = _.extend({}, Backbone.Events)

      # TODO: We need to get these in properly. Figure it out!
      @definitionId = options["definition"]
      window.apiServerUrl = options["apiServer"]
      appId = options["appId"] 
      forcefresh = options["forcefresh"]

      # Always create a user, initially as a guest if someone is not already loggedin
      @session = new Session(appId)
      if forcefresh 
        @session.logout()
      
      @setUpEventsAndViews()

    setUpEventsAndViews: ->
      @listenToOnce(@session, 'session:logged_in', @initialLoginCompleted)
      @listenTo(@session, 'session:show_dialog', @showLogin)
      @session.login(false)
      
      @assessment = new Assessment()
      @listenTo(@assessment, 'change:stage_completed', @stageCompleted)
      @listenTo(@assessment, 'stage_completed_success', @stageCompletedSuccess)

      @setUpSkelatalViews()

    setUpSkelatalViews: ->
      header = new HeaderView({model: @session})
      $('#header').html(header.render().el)
      @listenTo(header, 'header_view:login', @navigate('login', {trigger: true}))
      @listenTo(header, 'header_view:logout', @logout)

    stageCompleted: ->
      # Initially no stages completed, so start with -1
      @currentStageNo = @assessment.get('stage_completed')
      @numOfStages = @assessment.get('stages').length
      switch 
        when @currentStageNo is -1 then @navigate('start', {trigger: true})
        when @currentStageNo < @numOfStages then @navigate("stage/#{@currentStageNo}", {trigger: true})
        when @currentStageNo is @numOfStages then console.log("Waiting the final completed request to be sent.")
        else alert("Error in stages #{@currentStageNo}!")

    stageCompletedSuccess: ->
      # TODO: This is not ideal, but we need to first send the request to server, 
      # before logging the (guest) user out. That's why I added this here.
      @currentStageNo = @assessment.get('stage_completed')
      @numOfStages = @assessment.get('stages').length
      if @currentStageNo is @numOfStages
        @navigate("result", {trigger: true})

    showStart: ->
      console.log('Show Start')
      view = new StartView({model: @assessment})
      $('#content').html(view.render().el)

    showStages: ->
      console.log("Show Stage ##{@currentStageNo}")
      controller = new StagesController()
      controller.initialize({assessment: @assessment, currentStageNo: @currentStageNo})
      controller.render()

    showResult: ->
      console.log("Show Result")
      @result = new Result(@assessment.get('id'))
      controller = new SummaryResultsController()
      controller.initialize({assessment: @assessment, result: @result, session: @session})
      controller.render()      

    showDashboard: ->
      console.log("Showing Dashboard")
      view = new DashboardMainView({model: @result, assessment: @assessment})
      $('#content').html(view.render().el)

    # This can only be navigated to through the session.login command
    # DONOT call this directly
    # TODO: Needs refactoring, rather than a comment like above!
    showLogin: (options) ->
      console.log("Show Login")
      @navigate("login", {replace:true})
      silentLogin = options.hidden
      loginDialog = new LoginDialog({model: @session, silentLogin: silentLogin})
      $('#content').html(loginDialog.render().el)

    initialLoginCompleted: ->
      # Create an anonymous assessment on the server with the definitionId
      @assessment.save {'def_id': @definitionId },
        error: (model, xhr, options) =>
          # TODO: Error Message
          alert("Error!")
      @listenTo(@session, 'session:logged_in', @loginCompleted)

    loginCompleted: ->
      @navigate(window.currentLocation, {trigger: true})

    logout: ->
      @session.logout(true)
      .then =>
        @session.login(true)

  MainRouter
