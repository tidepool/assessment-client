define [
  'backbone'
], (
  Backbone
) ->

  Backbone.Model.extend
    defaults:
      reaction_time: null
      duration: null
      isDecoy: null

    initialize: ->

