define [
  'Backbone'], (Backbone) ->  
  Assessment = Backbone.Model.extend
    urlRoot: '/api/v1/assessments.json'

    initialize:  ->
      this.url = AssessmentsApp.apiServerUrl + this.urlRoot
 
  Assessment