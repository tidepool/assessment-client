define [
  'underscore',
  'Backbone'], (_, Backbone) ->  
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
          console.log("Error sending event")


  UserEvent
