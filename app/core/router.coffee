
define [
  'jquery'
  'backbone'
],
(
  $
  Backbone
) ->

  _me = 'routers/main_router'
  _welcomePageUrlPrefix = '/welcome/'

  MainRouter = Backbone.Router.extend
    routes:
      '':                       'showHome'
      home:                     'showHome'
      about:                    'showAbout'
      team:                     'showTeam'
      getStarted:               'getStarted'
      startGame:                'getStarted'
      demographics:             'showDemographics'
      'game/:def_id':           'createGame'
      game:                     'createDefaultGame'
      'gameResults/:id':        'showGameResults'
      dashboard:                'showDashboard'
      'dashboard-mood':         'showDashMood'
      'dashboard-productivity': 'showDashProductivity'
      'referrer/:refId':        'recordReferrer'
      'preferences-training':   'showTrainingPreferences'

    initialize: (appCoreSingleton) ->
      @app = appCoreSingleton
#      @on 'route', (r) -> console.log(''); console.log "Routing #{r}..." # Uncomment to show all the routes the app responds to


    # ------------------------------------------------ Route Handlers
    showHome: ->
      if @app.user.attributes.referred_by?
        window.location.href = _welcomePageUrlPrefix + @app.user.attributes.referred_by
      else
        @app.view.asSite 'pages/home'
    getStarted: ->
      if @app.user.attributes.personality?
        @navigate 'dashboard',
          trigger: true
          replace: true
      else
        @showDemographics()
    # Basic Site Pages
    showAbout: ->              @app.view.asSite 'pages/about'
    showTeam: ->               @app.view.asSite 'pages/team'
    showDemographics: ->       @app.view.asGame 'pages/demographics'
    # Game
    createDefaultGame: ->      @createGame 'baseline'
    createGame: (def_id) ->    @app.view.asGame 'pages/play_game', def_id:def_id
    showGameResults: (id) ->   @app.view.asGame 'pages/game_results', game_id:id
    # Dashboard
    showDashboard: ->          @app.view.asDash 'pages/dashboard/summary'
    showDashProductivity: ->   @app.view.asDash 'pages/dashboard/productivity'
    showDashMood: ->           @app.view.asDash 'pages/dashboard/mood'
    # Other
    recordReferrer: (refId) ->
      @app.analytics.track 'Referral', refId
      @app.user.set referred_by: refId
      @showDemographics()
      @navigate 'startGame', replace:true # Change, the url, but don't add to the browser's history stack
    showTrainingPreferences: ->
      console.log 'TODO: show training preferences'


  MainRouter



