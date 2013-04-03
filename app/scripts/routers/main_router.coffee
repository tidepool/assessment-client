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
  'assessments/results_view',
  'assessments/start_view',
  'assessments/stages_view',
  'components/progress_bar_view',
  'components/results_progress_bar_view'
  ], ($, Backbone, 
    Session, Assessment, UserEvent, User, Result, Stages, 
    LoginDialog, HeaderView, ResultsView, StartView, StagesView,
    ProgressBarView, ResultsProgressBarView) ->
  MainRouter = Backbone.Router.extend
    routes:
      'start': 'showStart'
      'stage/:stageNo': 'showStages'
      'result': 'showResult'
      'login': 'showLogin'

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
      @listenTo(header, 'login', @navigate('login', {trigger: true}))

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
      view = new StagesView({model: @assessment, currentStageNo: @currentStageNo})
      view.render()

    showResult: ->
      console.log("Show Result")
      if @session.user?
        isGuest = @session.user.get('guest')
        if isGuest?
          # First logout the guest user
          @session.logout()
          .then =>
            # Now login the user (no guest allowed)
            @session.login(true)
        else
          view = new ResultsProgressBarView()
          $('#content').html(view.render().el)
          @assessment.addUser(@session.user)
          .then =>
            @result = new Result(@assessment.get('id'))
            @result.calculateResult() 
          .then =>
            view = new ResultsView({model: @result, DoNotShowResults:false})
            $('#content').html(view.render().el)

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


  MainRouter
