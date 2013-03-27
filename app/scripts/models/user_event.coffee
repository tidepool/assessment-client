define [
  'Backbone'], (Backbone) ->  
  UserEvent = Backbone.Model.extend
    urlRoot: "/api/v1/user_events.json"

    initialize: ->
      @url = AssessmentsApp.apiServerUrl + @urlRoot

  UserEvent
