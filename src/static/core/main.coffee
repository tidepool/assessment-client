# Why is this file named `main`? About 'Packages' in require/commonJS:
# http://requirejs.org/docs/api.html#packages

define [
  # Global Dependencies
  'underscore'
  'backbone'
  # Package Dependencies
  './config'
  './analytics'
  './mediator'
  './view'
  './router'
  # External Dependencies
  'entities/user'
  'controllers/session_controller'
  # 3rd Party Dependencies
  'fastclick'
],
(
  _
  Backbone
  config
  Analytics
  Mediator
  View
  Router
  User
  SessionController
  FastClick
) ->

  _me = 'core/main'

  Core = ->
    #config.debug && console.log "#{_me} instantiated"
    _.extend this, Backbone.Events
    # Log all Events the app core processes by uncommenting the following line
    #@cfg.debug && @on 'all', (e) -> @cfg.debug && console.log "#{_me} event: #{e}"
    @

  Core.prototype =
    start: (options) ->
      @cfg = _.extend config, options # Extend the application configuration with build options
      @user = new User()

      # Handle click/tap differences with this polyfill
      FastClick.attach document.body

      #@cfg.debug && console.log "#{_me} started"

      # Analytics is fired up
      @analytics = new Analytics @cfg

      # In the beginning the session was created
      @session = new SessionController
        app: @

      @user.session = @session

      # The application manages all of its views starting with this one
      @view = new View
        app: @
      # Application commands are managed by a mediator
      @mediator = new Mediator
        app: @
      # Url Routes are listened to
      @router = new Router @
      Backbone.history.start()
      @



  # Publicize a singleton
  new Core()