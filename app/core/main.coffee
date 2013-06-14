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
  # External Dependencies
  'entities/user'
  'controllers/session_controller'
  'routers/main_router'
],
(
  _
  Backbone
  config
  Analytics
  Mediator
  View
  User
  SessionController
  Router
) ->

  _me = 'core/main'

  Core = ->
    #config.debug && console.log "#{_me} instantiated"
    @cfg = config
    _.extend this, Backbone.Events
    #@cfg.debug && @on 'all', (e) -> @cfg.debug && console.log "#{_me} event: #{e}"
    @user = new User()
    @

  Core.prototype =
    start: ->
      #@cfg.debug && console.log "#{_me} started"
      # In the beginning the session was created
      @session = new SessionController
        user: @user
        cfg: @cfg

      @user.session = @session
      # Analytics is fired up
      new Analytics @cfg
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
  core = new Core()
