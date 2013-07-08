define [
  'backbone'
  'entities/results/result'
  'core'
], (
  Backbone
  Result
  app
) ->

  _me = 'entities/results/results'

  Collection = Backbone.Collection.extend

    url: -> "#{app.cfg.apiServer}/api/v1/users/-/results"

    model: Result

    initialize: ->
      @on 'error', @onErr

    # ------------------------------------------------------------- Callbacks
    onErr: -> console.error "#{_me}: error"

  Collection.STATES = Result.STATES
  Collection

