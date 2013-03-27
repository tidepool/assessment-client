define [
  'Backbone'], (Backbone) ->  
  Result = Backbone.Model.extend
    initialize: (assessment_id) ->
      @url = "#{AssessmentsApp.apiServerUrl}/api/v1/assessments/#{assessment_id}/results.json"

  Result
