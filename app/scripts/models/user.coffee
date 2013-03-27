define [
  'Backbone'], (Backbone) ->  
  User = Backbone.Model.extend
    initialize:  ->
      @url = "#{AssessmentsApp.apiServerUrl}/api/v1/me.json"

    addAssessment: (assessment) ->

  User
    