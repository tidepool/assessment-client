
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
  _reroute =
    trigger: true # go there
    replace: true # replace the url


  MainRouter = Backbone.Router.extend
    routes:
      '':                       'showHome'
      'def':                    'showDefault'
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
      'do/logIn/:token':        'doLogIn'


    initialize: (appCoreSingleton) ->
      @app = appCoreSingleton
#      @on 'route', (r) -> console.log "Routing #{r}..." # Uncomment to show all the routes the app responds to


    # ------------------------------------------------- Private Methods
    _logInUsingToken: (token) ->
      @listenToOnce @app.user, 'error', (model, xhr) -> @showError xhr.responseJSON.status.message, model
      @app.user.reset(token).fetch()
      @


    # ------------------------------------------------ Location Route Handlers
    showDefault: ->                  @showDefaultPage()
    showHome: ->                     @app.view.asSite 'pages/home'
    getStarted: ->
      if @app.user.attributes.personality?
        @navigate 'dashboard', _reroute
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
      @_logInUsingToken token

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
      @navigate 'dashboard', _reroute
      @app.trigger 'action:showPersonalizations'


    # ------------------------------------------------- Action/Verb Routes
    doLogIn: (token) ->
      console.log "logInUsingToken: #{token}"
      @listenToOnce @app.user, 'sync', ->
        @app.analytics.track 'session', 'Successful External Auth Login'
        @showDefaultPage()
      @_logInUsingToken token


    # ------------------------------------------------- Route Helpers
    showError: (message, object) ->  @app.view.asSite 'pages/error', { message:message, object:object }

    # Show whatever the default page is for this application and user state.
    showDefaultPage: ->
#      console.log
#        isUnfetched: @app.user.isUnfetched()
#        isGuest: @app.user.isGuest()
#        isLoggedIn: @app.user.isLoggedIn()
#        hasPersonality: @app.user.attributes.personality?
#        user: @app.user.toJSON()

      if @app.user.isLoggedIn() and @app.user.isGuest()
        if @app.user.attributes.personality?
          console.log user:@app.user.attributes
          @navigate 'home', _reroute                             # Guest with Personality
        else
          @navigate 'home', _reroute                             # Guest without
      else if @app.user.isLoggedIn()
        if @app.user.isUnfetched()
          console.log 'showDefaultPage(): unfetched user'
          @listenToOnce @app.user, 'sync', @showDefaultPage      # User with a token, but not fetched so of unknown status
        else if @app.user.attributes.personality?
          @navigate 'dashboard', _reroute                        # User with personality
        else
          @navigate 'getStarted', _reroute                       # User without
      else
        @navigate 'home', _reroute                               # Non-user

      @


  MainRouter



