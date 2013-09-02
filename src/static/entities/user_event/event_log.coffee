define [
  'underscore'
  'classes/model'
  'core'
  'entities/daddy_ios'
], (
  _
  Model
  app
  ios
) ->


  Export = Model.extend
    url: -> "#{app.cfg.apiServer}/api/v1/users/-/games/#{@attributes.game_id}/event_log"
    isNew: -> false # Always do a PUT, not a POST
    defaults: -> event_log: [] # An event log object has many _event_bundles


    # --------------------------------------------------- Backbone Methods
    initialize: ->
      #@on 'sync', @onSync
      @on 'error', @onErr

    validate: (attrs, options) ->
      return 'Can\'t save unless there is at least 1 event_log entry' unless attrs.event_log.length > 0
      null # no errors


    # --------------------------------------------------- Private Methods


    # --------------------------------------------------- Event Handling
    #onSync: (model) -> console.log eventLog: model.attributes
    onErr: (model, xhr) ->
      msg = xhr.responseJSON?.status.message || xhr.statusText
      ios.error msg
      console.error
        message: msg
        model: model
        xhr: xhr
#      throw new Error 'Error syncing user_event'


    # --------------------------------------------------- Consumable API
    addEvent: (eventBundle) -> @push 'event_log', eventBundle.toJSON()



  Export


