
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
      'gameForUser/:token':     'createGameForUser'
      'gameResults/:id':        'showGameResults'
      dashboard:                'showDashboard'
      'dashboard-mood':         'showDashMood'
      'dashboard-personality':  'showDashPersonality'
      'dashboard-productivity': 'showDashProductivity'
      'referrer/:refId':        'recordReferrer'
      'preferences-training':   'showTrainingPreferences'
      'friendHelper/:uid/:gid': 'showFriendHelper'
      'friendResults/:gid':     'showFriendResults'
      'logInUsingToken/:token': 'logInUsingToken'


    initialize: (appCoreSingleton) ->
      @app = appCoreSingleton
#      @on 'route', (r) -> console.log(''); console.log "Routing #{r}..." # Uncomment to show all the routes the app responds to


    # ------------------------------------------------- Private Methods
    _logIn: (token) ->
      @listenToOnce @app.user, 'error', (model, xhr) -> @showError xhr.responseJSON.status.message, model
      @app.user.reset(token).fetch()
      @


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
        @createDefaultGame()
    # Basic Site Pages
    showAbout: ->                    @app.view.asSite 'pages/about'
    showTeam: ->                     @app.view.asSite 'pages/team'
    showDemographics: ->             @app.view.asGame 'pages/demographics'
    # Game
    createDefaultGame: ->            @createGame 'baseline'
    createGame: (def_id) ->          @app.view.asGame 'pages/play_game', def_id:def_id
    createGameForUser: (token) ->
      @listenToOnce @app.user, 'sync', ->               @createGame 'baseline'
      @listenToOnce @app.user, 'error', (model, xhr) -> @showError xhr.responseJSON.status.message, model
      @app.user.reset(token).fetch()

    showGameResults: (id) ->         @app.view.asGame 'pages/game_results', game_id:id
    # Dashboard
    showDashboard: ->                @app.view.asDash 'pages/dashboard/summary'
    showDashProductivity: ->         @app.view.asDash 'pages/dashboard/productivity'
    showDashMood: ->                 @app.view.asDash 'pages/dashboard/mood'
    showDashPersonality: ->          @app.view.asDash 'pages/dashboard/personality'
    showFriendHelper: (uid, gid) ->  @app.view.asGame 'pages/friend_survey', user_id:uid, game_id:gid
    showFriendResults: (gid) ->      @app.view.asGame 'pages/social_results', game_id:gid
    # Other
    recordReferrer: (refId) ->
      @app.analytics.track 'Referral', refId
      @app.user.set referred_by: refId
      @showDemographics()
      @navigate 'startGame', replace:true # Change, the url, but don't add to the browser's history stack
    showTrainingPreferences: ->
      @navigate 'dashboard'
      @app.trigger 'action:showPersonalizations'
    logInUsingToken: (token) ->
      console.log "logInUsingToken: #{token}"
      @listenToOnce @app.user, 'sync', -> @showDashboard()
      @_logIn token



    # ------------------------------------------------- Route Helpers
    showError: (message, object) ->  @app.view.asSite 'pages/error', { message:message, object:object }


  MainRouter



