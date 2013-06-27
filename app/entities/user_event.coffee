define [
  'underscore'
  'backbone'
  'core'
], (
  _
  Backbone
  app
) ->

  _me = 'entities/user_event'


  UserEvent = Backbone.Model.extend
    urlRoot: "#{app.cfg.apiServer}/api/v1/user_events"

    defaults: ->
      {
        game_id: null # The game instance id
#        event_type: null
        module: null # The string id of the level type (eg: 'rank_images')
        stage: null # The index of the level instance (eg: 0 is the first level in the game)
        record_time: new Date().getTime()
        event_desc: 'Default Event Description'
      }

    initialize: ->
      @on 'sync', @onSync
      @on 'error', @onErr

    send: ->
      console.warn ".send is depreciated. Use standard backbone model .save() instead"
      @save()
      return this

    onSync: (model) ->
      console.log "#{_me}.save().success()"
      console.log model.attributes
    onErr: ->
      console.error "#{_me}.save().error()"

  UserEvent
