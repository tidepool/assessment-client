define [
  'backbone'
],
(
  Backbone
) ->

  # A Single Image
  _meModel = 'game/levels/circle_proximity/circles Model'
  Model = Backbone.Model.extend
    defaults:
      size: 5
      trait1: ''
      trait2: ''
      abbreviation: ''
      image: null # Used if there should be an image in the circle
      #iconClass: icon-user # Used if there should be an icon in the circle
      userChangedSize: false
      userChangedPos: false
    initialize: ->
      @_calcAbbreviation()
    _calcAbbreviation: ->
      t1 = @get('trait1').charAt 0
      t2 = @get('trait2').charAt 0
      abbr = "#{t1}<em>/</em>#{t2}"
      @set 'abbreviation', abbr

  # A Collection of Game Levels
  _meCollection = 'game/levels/circle_proximity/circles Collection'
  Collection = Backbone.Collection.extend
    model: Model


  Collection




