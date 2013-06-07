define [
  'backbone'
  './rankable_image_view'
],
(
  Backbone
  RankableImageView
) ->

  # A Single Image
  _meModel = 'game/levels/rank_images/rankable_images Model'
  Model = Backbone.Model.extend
    defaults:
      rank: null
    initialize: ->
      @view = new RankableImageView
        model: @

  # A Collection of Game Levels
  _meCollection = 'game/levels/rank_images/rankable_images Collection'
  Collection = Backbone.Collection.extend
    model: Model


  Collection




