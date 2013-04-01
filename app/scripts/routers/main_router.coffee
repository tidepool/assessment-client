define [
  'jquery',
  'Backbone',
  '../models/session', 
  '../models/assessment',
  '../models/user_event',
  '../models/user',
  '../models/result',
  '../collections/stages',
  '../views/assessments/login_dialog',
  '../views/assessments/header_view',
  '../views/assessments/results_view',
  '../views/assessments/start_view',
  '../views/assessments/stages_view',
  '../views/components/progress_bar_view',
  '../views/components/results_progress_bar_view'
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

      # Always create a user, initially as a guest if someone is not already loggedin
      @session = new Session(appId)
      @listenTo(@session, 'session:logged_in', @loginCompleted)
      @listenTo(@session, 'session:show_dialog', @showLogin)
      @session.login(false)
      
      @assessment = new Assessment()
      @listenTo(@assessment, 'change:stage_completed', @stageCompleted)

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
        when @currentStageNo is @numOfStages then @navigate("result", {trigger: true})
        else alert("Error in stages #{@currentStageNo}!")

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
      silentLogin = options.hidden
      loginDialog = new LoginDialog({model: @session, silentLogin: silentLogin})
      $('#loginView').html(loginDialog.render().el)

    loginCompleted: ->
      # Create an anonymous assessment on the server with the definitionId
      @assessment.save {'def_id': @definitionId },
        error: (model, xhr, options) =>
          # TODO: Error Message
          alert("Error!")

  MainRouter
