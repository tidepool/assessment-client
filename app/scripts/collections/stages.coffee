define [
  'Backbone',
  'models/stage'], (Backbone, Stage) ->  
  Stages = Backbone.Collection.extend
    model: Stage
  
  Stages
