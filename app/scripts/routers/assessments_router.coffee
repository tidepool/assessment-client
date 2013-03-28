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
  '../views/components/progress_bar_view',
  '../views/components/results_progress_bar_view',
  '../views/stages/circles_test',
  '../views/stages/image_rank',
  '../views/stages/reaction_time'
  ], ($, Backbone, 
    Session, Assessment, UserEvent, User, Result, Stages, 
    LoginDialog, HeaderView, ResultsView, StartView,
    ProgressBarView, ResultsProgressBarView, 
    CirclesTest, ImageRank, ReactionTime) ->
  AssessmentsRouter = Backbone.Router.extend
    routes:
      'stage/:stageNo': 'nextStage'
      'result': 'showResult'

    views:
      'ReactionTime': 'AssessmentsApp.Views.ReactionTime'
      'ImageRank': 'AssessmentsApp.Views.ImageRank'
      'CirclesTest': 'AssessmentsApp.Views.CirclesTest'

    initialize: (options) ->
      @eventDispatcher = _.extend({}, Backbone.Events)
      @eventDispatcher.bind("startAssessment", @startAssessment)
      @eventDispatcher.bind("userEventCreated", @userEventCreated)
      # @eventDispatcher.bind("loginDialogStart", @loginDialogStart)
      # @eventDispatcher.bind("loginDialogEnd", @loginDialogEnd)
      # @eventDispatcher.bind("logoutRequest", @logoutRequest)

      # TODO: We need to get these in properly. Figure it out!
      definitionId = options["definition"] || 1
      window.apiServerUrl = options["api_server"] || "http://api-server.dev"
      appId = options["app_id"] || "efd40076811c4a9566dd970642dc572151f9e45b75a2fd4f3d2956811b4066b5"
      
      @session = new Session(appId)
      header = new HeaderView({model: @session, eventDispatcher: @eventDispatcher})
      $('#header').html(header.render().el)

      @assessment = new Assessment()
      attribs = {'def_id': definitionId }
      @assessment.save attribs,
        success: (model, response, options) =>
          @setUpViews()
          @currentStageNo = @assessment.get('stage_completed') + 1
        error: (model, xhr, options) =>
          # TODO: Error Message
          alert("Error!")

    setUpViews: ->
      view = new StartView({model: @assessment, eventDispatcher: @eventDispatcher})
      $('#content').html(view.render().el)

    stringToFunction: (str) ->
      namespace = str.split(".")
      func = (window || this)
      for newFunc in namespace
        func = func[newFunc]
      if (typeof func isnt "function")
        throw new Error("function not found")
      func

    getQueryParam: (param) ->
      query = window.location.search.substring(1)
      qParams = query.split("&")
      for qParam in qParams
        pair = qParam.split("=")
        if pair[0] == param
          return unescape(pair[1])
      return false

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

    assessmentProgress: (stage) ->
      # Rails 4 is going to introduce support for the PATCH verb in HTTP
      # TODO: Switch to PATCH when Rails 4 switch happens
      attrs = { 'stage_completed': stage }
      @assessment.save attrs,
        patch: false
        success: (model, response, options) =>

        error: (model, xhr, options) =>



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

        @assessmentProgress(priorStage)
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
  AssessmentsRouter
