
define [
  'backbone'
  'core'
], (
  Backbone
  app
) ->

  _me = 'entities/cur_user_personality'

  Model = Backbone.Model.extend

    url: "#{app.cfg.apiServer}/api/v1/users/37/personality" #TODO: remove the reference to a specific user's id

    initialize: ->
      @fetch()
      @on 'error', @onModelErr

    onModelErr: -> console.error "#{_me}: Trouble getting the User Personality Model"

  Model

