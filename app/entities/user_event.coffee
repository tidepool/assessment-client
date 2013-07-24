define [
  'underscore'
  'classes/model'
  'core'
], (
  _
  Model
  app
) ->

  _me = 'entities/user_event'


  UserEvent = Model.extend
    urlRoot: "#{app.cfg.apiServer}/api/v1/user_events"

    defaults: ->
      {
        game_id: null # The game instance id
#        event_type: null
        module: null # The string id of the level type (eg: 'rank_images')
        stage: null # The index of the level instance (eg: 0 is the first level in the game)
        record_time: (new Date()).getTime()
        timezone_offset: (new Date).getTimezoneOffset()
        event_desc: 'Default Event Description'
      }

    initialize: ->
      @on 'sync', @onSync
      @on 'error', @onErr

    onSync: (model) ->
#      console.log "#{_me}.save().success()"
      # ------------------------------------------------------ v Line of Awesome
#      console.log model.attributes # Uncomment this to view real-time details of every saved user event
      # ------------------------------------------------------ ^ Line of Awesome

    onErr: ->
      console.error "#{_me} error event"

  UserEvent


