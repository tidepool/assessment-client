define [
  'underscore'
  'classes/model'
  './_events'
  'core'
], (
  _
  Model
  Events
  app
) ->


  Export = Model.extend
    url: -> "#{app.cfg.apiServer}/api/v1/users/-/games/#{@attributes.game_id}/event_log"

    defaults: ->
      {
        event_type: null # The string id of the level type (eg: 'image_rank')
        stage: null # The index of the level instance (eg: 0 is the first level in the game)
        events: new Events()
      }

    # --------------------------------------------------- Backbone Methods
    initialize: ->
      throw new Error 'Need event_type' unless @attributes.event_type
      throw new Error 'event_type should be a string' unless typeof @attributes.event_type is 'string'
      throw new Error 'Need stage' unless @attributes.stage
      throw new Error 'stage should be a number' unless typeof @attributes.stage is 'number'
      throw new Error 'Need game_id' unless @attributes.game_id
      @on 'sync', @onSync
      @on 'error', @onErr

    validate: (attrs, options) ->
      return 'Can\'t save unless there is at least 1 event' unless attrs.events.length > 0
      return null # no errors

    toJSON: (options) ->
      attrs = _.clone(this.attributes)
      attrs.events = attrs.events.toJSON()
      attrs

    # --------------------------------------------------- Event Handling
    onSync: (model) ->
#      console.log "#{_me}.save().success()"
      # ------------------------------------------------------ v Line of Awesome
      console.log model.attributes # Uncomment this to view real-time details of every saved user event
      # ------------------------------------------------------ ^ Line of Awesome

    onErr: -> console.error "Error with user_event"


    # --------------------------------------------------- Consumable API
    record: (eventData, options) ->
      @attributes.events.add eventData, _.extend({validate:true}, options)


  Export


