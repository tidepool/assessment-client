
define [
  'jquery'
  'backbone'
],
(
  $
  Backbone
) ->
  _me = 'routers/main_router'

  MainRouter = Backbone.Router.extend
    routes:
      '':           'showHome'
      home:         'showHome'
      about:        'showAbout'
      team:         'showTeam'
      game:         'showGame'
      guestSignup:  'showGuestSignup'
      dashboard:    'showDashboard'

    initialize: (appCoreSingleton) ->
      @app = appCoreSingleton
  #@on 'route', (r) -> console.log(''); console.log "Routing #{r}..."


  # ------------------------------------------------ Actual Route Responses
    showHome: ->        @app.view.asSite 'pages/home'
    showAbout: ->       @app.view.asSite 'pages/about'
    showTeam: ->        @app.view.asSite 'pages/team'
    showGame: ->        @app.view.asGame 'pages/play_game'
    showGuestSignup: -> @app.view.asGame 'pages/guest_signup'
    showDashboard: ->   @app.view.asDash 'pages/dashboard/personality'


  MainRouter
