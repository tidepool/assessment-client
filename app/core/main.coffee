# Why is this file named `main`? About 'Packages' in require/commonJS:
# http://requirejs.org/docs/api.html#packages

define [
  'Backbone'
  './config'
  './analytics'
  './router'
],
(
  Backbone
  config
  Analytics
  Router
) ->

  _me = 'core/main'
  console.log "Parsing #{_me}"

  Core = ->
    console.log "#{_me} instantiated"
    @cfg = config
    new Analytics @cfg
    @

  Core.prototype =
    start: ->
      console.log "#{_me} started"
      new Router @cfg
      Backbone.history.start()
      @

  new Core()


