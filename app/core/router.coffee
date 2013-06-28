
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
      '':                  'showHome'
      home:                'showHome'
      about:               'showAbout'
      team:                'showTeam'
      startGame:           'showDemographics'
      demographics:        'showDemographics'
      'game/:def_id':      'createGame'
      game:                'createDefaultGame'
      guestSignup:         'showGuestSignup'
      dashboard:           'showDashboard'
      'dashboard-career':  'showDashCareer'
      'referrer/:refId':   'recordReferrer'

    initialize: (appCoreSingleton) ->
      @app = appCoreSingleton
#      @on 'route', (r) -> console.log(''); console.log "Routing #{r}..."


    # ------------------------------------------------ Actual Route Responses
    showHome: ->
      if @app.user.attributes.referred_by?
        window.location.href = _welcomePageUrlPrefix + @app.user.attributes.referred_by
      else
        @app.view.asSite 'pages/home'
    showAbout: ->        @app.view.asSite 'pages/about'
    showTeam: ->         @app.view.asSite 'pages/team'
    showDemographics: -> @app.view.asGame 'pages/demographics'
    createDefaultGame: ->
      @createGame 'baseline'
    createGame: (def_id) ->
      @app.view.asGame 'pages/play_game', def_id:def_id
#    showGame: ->         @app.view.asGame 'pages/play_game'
    showGuestSignup: ->  @app.view.asGame 'pages/guest_signup'
    showDashboard: ->    @app.view.asDash 'pages/dashboard/all'
    showDashCareer: ->   @app.view.asDash 'pages/dashboard/career'
    recordReferrer: (refId) ->
      @app.analytics.track 'Referral', refId
      @app.user.set referred_by: refId
      @showDemographics()
      @navigate 'startGame', replace:true # Change, the url, but don't add to the browser's history stack

  MainRouter



