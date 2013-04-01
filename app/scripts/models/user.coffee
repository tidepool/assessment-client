define [
  'Backbone'], (Backbone) ->  
  User = Backbone.Model.extend
    initialize:  ->
      @url = "#{window.apiServerUrl}/api/v1/me"

    addAssessment: (assessment) ->

  User
    