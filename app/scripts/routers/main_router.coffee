define [
  'jquery'
  'backbone'
  'models/result'
  'controllers/dashboard_controller'
],
(
  $
  Backbone
  Result
  DashboardController
) ->
  _me = 'routers/main_router'

  MainRouter = Backbone.Router.extend
    routes:
      '': 'showHome'
      'about': 'showAbout'
      'team': 'showTeam'
      'investors': 'showInvestors'
      'game': 'showGame'
      'result': 'showResult'
      'dashboard': 'showDashboard'

    initialize: (appCoreSingleton) ->
      @app = appCoreSingleton
      #@on 'route', (r) -> console.log(''); console.log "Routing #{r}..."

    # ------------------------------------------------ Actual Route Responses
    showHome: ->      @app.view.asSite 'pages/home'
    showAbout: ->     @app.view.asSite 'pages/about'
    showTeam: ->      @app.view.asSite 'pages/team'
    showInvestors: -> @app.view.asSite 'pages/investors'
    showGame: ->      @app.view.asGame 'pages/playGame'
    showResult: ->    @app.view.asGame 'pages/gameResult'
    showDashboard: -> @app.view.asDash 'pages/dashboard/personality'
#      console.log "#{_me}.showDashboard()"
#      controller = new DashboardController()
#      controller.initialize
#        session: @app.user.session
#      controller.render()


    # ----------------------------- Supporting Methods
#    _stageCompletedSuccess: ->
#      # TODO: This is not ideal, but we need to first send the request to server,
#      # before logging the (guest) user out. That's why I added this here.
#      @currentStageNo = @app.session.assessment.get('stage_completed')
#      @numOfStages = @app.session.assessment.get('stages').length
#      if @currentStageNo is @numOfStages
#        @navigate("result", {trigger: true})



  MainRouter
