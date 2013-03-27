define [
  'Backbone'], (Backbone) ->  
  Assessments = Backbone.Collection.extend
    url: '/api/v1/assessments'

  Assessments
