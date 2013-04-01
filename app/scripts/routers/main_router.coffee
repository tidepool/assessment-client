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
  '../views/components/results_progress_bar_view',
  '../views/stages/circles_test',
  '../views/stages/image_rank'
  ], ($, Backbone, 
    Session, Assessment, UserEvent, User, Result, Stages, 
    LoginDialog, HeaderView, ResultsView, StartView, StagesView,
    ProgressBarView, ResultsProgressBarView, 
    CirclesTest, ImageRank) ->
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

      # Always create a user, initially as a guest
      @session = new Session(appId)
      @listenTo(@session, 'session:logged_in', @loginCompleted)
      @listenTo(@session, 'session:show_dialog', @showLogin)
      @session.login(true)
      
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
          @session.login(false)
        else
          @session.user.addAssessment(@assessment)
          @assessment.calculateResult() 

      view = new ResultsView({model: @session, assessment: @assessment, noResults:true})
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


    startAssessment: =>
      @stages = new Stages(@assessment.get('stages'))
      @progressBarView = new ProgressBarView({numOfStages: @stages.length})
      $('#progressbarcontainer').html(@progressBarView.render().el)
      @nextStage(@currentStageNo)

    userEventCreated: (userEvent) =>
      newUserEvent = _.extend({}, userEvent, {"assessment_id": @assessment.get('id'), "user_id": @assessment.get('user_id')})
      eventModel = new UserEvent(newUserEvent)
      eventModel.save {},
        error:@handleError

    handleError: (model, xhr, options) =>
      # TODO: Error handling for failed event saves

    tryResult: (assessmentId) =>
      setTimeout =>
        @assessment.id = assessmentId
        @assessment.fetch 
          data: { results: true },
          success: @handleAssessmentResults
          error: @handleFailedAssessmentResults
      , 2000

    handleAssessmentResults: (model, response, options) =>
      if response.status is 206
        @tryResult(@assessment.id)
        return
      profileDesc = @assessment.get('profile_description')
      if profileDesc?
        view = new ResultsView({model: profileDesc, eventDispatcher: @eventDispatcher})
        $('#content').html(view.render().el)
      else
        @tryResult(@assessment.id)
        return

    handleFailedAssessmentResults: (model, xhr, options) =>
      # TODO: Error handling for failed results

    showResult: ->
      definition = @assessment.get('definition')
      if definition.experiment is 'MT'
        # This is for the Mechanical Turk experiments
        # Donot show the results to Mechanical Turk participants 
        view = new ResultsView({model: {}, eventDispatcher:@eventDispatcher, noResults:true})
        $('#content').html(view.render().el)
        return

      if @session.loggedIn()
        # User already logged in
        view = new ResultsProgressBarView()
        $('#content').html(view.render().el)

        
        result = new Result(@assessment.id)
        attribs = {}
        result.save attribs,
          success: (model, response, options) =>
            result = response
            foo = model
          error: (model, xhr, options) =>
            # TODO: Error Message
            alert("Error!")

        # @tryResult(@assessment.id)
      else
        # Login
        loginDialog = new LoginDialog({model: @session, nextRoute: "/result", eventDispatcher: @eventDispatcher})    
        loginDialog.display()
     
    nextStage: (stageNo) =>
      stageNo = parseInt(stageNo)

      priorStage = stageNo - 1
      if priorStage >= 0
        stageCompleted = @assessment.get('stage_completed')
        if stageCompleted isnt priorStage - 1
          # Jumping to far! Prevent jumping back and forth
          stageNo = stageCompleted + 1
          priorStage = stageNo - 1

        @assessment.updateProgres priorStage
        @progressBarView.setStageCompleted(priorStage)

      @currentStageNo = stageNo
      if stageNo >= @stages.length
        # Final stage
        # event_type:1 will trigger the calculation in the backend
        @showResult()
      else
        @stage = @stages.at(stageNo)
        viewClass = @stringToFunction(@views[@stage.get('view_name')])
        view = new viewClass({model: @stage, eventDispatcher: @eventDispatcher, nextStage: stageNo + 1})
        $('#content').html(view.render().el)
  MainRouter
