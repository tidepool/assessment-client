# Why is this file named `main`? About 'Packages' in require/commonJS:
# http://requirejs.org/docs/api.html#packages

define [
  'underscore'
  'Backbone'
  './config'
  './analytics'
  './mediator'
  './view'
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
  SessionController
  Router
) ->

  _me = 'core/main'

  Core = ->
    config.debug && console.log "#{_me} instantiated"
    @cfg = config
    _.extend this, Backbone.Events
    @on 'all', (e) -> @cfg.debug && console.log "#{_me} event: #{e}"
    @

  Core.prototype =
    start: ->
      @cfg.debug && console.log "#{_me} started"
      # In the beginning the session was created
      @session = new SessionController()
      @session.initialize @
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
