# Why is this file named `main`? About 'Packages' in require/commonJS:
# http://requirejs.org/docs/api.html#packages

define [
  'underscore'
  'Backbone'
  './config'
  './analytics'
  'routers/main_router'
],
(
  _
  Backbone
  config
  Analytics
  Router
) ->

  _me = 'core/main'

  Core = ->
    config.debug && console.log "#{_me} instantiated"
    @cfg = config
    _.extend @, Backbone.Events
    @

  Core.prototype =
    start: ->
      @cfg.debug && console.log "#{_me} started"
      new Analytics @cfg
      new Router @cfg
      Backbone.history.start()
      @

  new Core()


