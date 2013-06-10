define [
  'backbone'
],
(
  Backbone
) ->


  # --------------------------------------------------------------------- Model
  _me = 'game/levels/circle_proximity/self'
  Model = Backbone.Model.extend
    defaults:
      pxSize: 200 # Needed in px for back end processing
      top: 175
      left: 0

    initialize: ->
      @set 'size', @get 'pxSize'

  Model





