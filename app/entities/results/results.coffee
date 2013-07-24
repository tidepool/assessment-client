define [
  'classes/collection'
  'entities/results/result'
  'core'
], (
  Collection
  Result
  app
) ->

  _me = 'entities/results/results'

  Export = Collection.extend

    url: -> "#{app.cfg.apiServer}/api/v1/users/-/results"
    model: Result
    initialize: -> @on 'error', @onErr
    onErr: -> console.error "#{_me}: error"

  Export.STATES = Result.STATES
  Export

