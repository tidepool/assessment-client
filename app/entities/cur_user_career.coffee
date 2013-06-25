
define [
  'backbone'
  'core'
  'markdown'
], (
  Backbone
  app
  markdown
) ->

  _me = 'entities/cur_user_pcareer'

  Model = Backbone.Model.extend

    url: "#{app.cfg.apiServer}/api/v1/users/-/recommendations/career"

    initialize: ->
      @on 'sync', @onSync
      @on 'error', @onErr

    onSync: (model) ->
#      console.log model: model.attributes
    onErr: -> console.error "#{_me}: Trouble getting model data"

  Model

