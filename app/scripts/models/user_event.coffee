define [
  'Backbone'], (Backbone) ->  
  UserEvent = Backbone.Model.extend
    urlRoot: "/api/v1/user_events.json"

    initialize: ->
      @url = window.apiServerUrl + @urlRoot

  UserEvent
