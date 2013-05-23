define [
  'jquery'
  'Backbone'
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
      @on 'route', (r) -> console.log(''); console.log "Routing #{r}..."

    # ------------------------------------------------ Actual Route Responses
    showHome: ->      @app.view.asSite 'pages/home'
      #if @app.session.loggedIn() and not @app.session.user?
      #  @app.session.loginAsCurrent()
    showAbout: ->     @app.view.asSite 'pages/about'
    showTeam: ->      @app.view.asSite 'pages/team'
    showInvestors: -> @app.view.asSite 'pages/investors'
    showGame: ->      @app.view.asGame 'pages/game'
    showResult: ->    @app.view.asGame 'pages/gameResult'

    showDashboard: ->
      console.log "#{_me}.showDashboard()"
      # Only show it, if the user is not guest and is logged in
#      if (@app.session.user? and @app.session.user.isGuest()) or not @app.session.loggedIn()
#        loginDialog = new LoginDialog({session: @app.session})
#        $('#content').html loginDialog.render().el
#      else
      if @app.session.user?
        controller = new DashboardController()
        controller.initialize
          session: @app.session
        controller.render()
      else
        @app.session.loginAsCurrent()
          .done =>
            controller = new DashboardController()
            controller.initialize
              session: @app.session
            controller.render()
          .fail =>
            console.log("Something went wrong, cannot log in")



    # ----------------------------- Supporting Methods
#    _stageCompletedSuccess: ->
#      # TODO: This is not ideal, but we need to first send the request to server,
#      # before logging the (guest) user out. That's why I added this here.
#      @currentStageNo = @app.session.assessment.get('stage_completed')
#      @numOfStages = @app.session.assessment.get('stages').length
#      if @currentStageNo is @numOfStages
#        @navigate("result", {trigger: true})



  MainRouter
