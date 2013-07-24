
define [
  'classes/model'
  'core'
], (
  Model
  app
) ->


  Export = Model.extend

    url: "#{app.cfg.apiServer}/api/v1/users/-/recommendations/career"

    initialize: ->
      @on 'sync', @onSync
      @on 'error', @onErr

    onSync: (model) ->
#      console.log model: model.attributes
    onErr: -> console.error "Trouble getting model data"

  Export

