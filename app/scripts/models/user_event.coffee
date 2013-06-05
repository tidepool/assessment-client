define [
  'underscore'
  'backbone'
], (
  _
  Backbone
) ->

  _me = 'models/user_event'


  UserEvent = Backbone.Model.extend
    urlRoot: "/api/v1/user_events"

    initialize: ->
      @url = window.apiServerUrl + @urlRoot

    send: (attribs) ->
      timestamp = new Date().getTime()
      defaultInfo = 
        "record_time": timestamp

      eventInfo = _.extend({}, defaultInfo, attribs)
      @save eventInfo,
        error: ->
          console.log "#{_me}.save().error()"
        success: (model) ->
          console.log "#{_me}.save().success()"
          console.log model.attributes


  UserEvent
