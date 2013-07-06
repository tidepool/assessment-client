define [
  'backbone'
],
(
  Backbone
) ->


  # --------------------------------------------------------------------- Model
  _me = 'game/levels/circle_proximity/circles'
  Model = Backbone.Model.extend
    maxSize: 4
    sizeToScale: [
      0.4
      0.7
      1.0
      1.3
      1.6
    ]
    sizeToClass: [
      'size1'
      'size2'
      'size3'
      'size4'
      'size5'
    ]
    defaults:
      selfProximityPx: null
      selfProximityRank: null
      selfOverlapPx: null
      selfOverlapRatio: null
      image: null # Used if there should be an image in the circle
      #iconClass: icon-user # Used if there should be an icon in the circle
      userChangedSize: false
      userChangedPos: false
      width: null # px width needed for the back end's calculations
      top: 0
      left: 0
      pos: # This is used so that other objects can observe a single property for position
        x: 0
        y: 0

    initialize: ->
      @_calcAbbreviation()
      @_calcImageUrl()
      @set 'size', 2 #@get('size') - 1 #TODO: remove this. temp kludge because the data is sending sizes with '5', but the scale is 0-4
      @on 'change:size', @onChangeSize
      @on 'change:pos', @onChangePos

    _calcAbbreviation: ->
      t1 = @get('trait1')
      t2 = @get('trait2')
      return unless t1 and t2
      t1 = t1.charAt 0
      t2 = t2.charAt 0
      abbr = "#{t1}<em>/</em>#{t2}"
      @set 'abbreviation', abbr

    _calcImageUrl: ->
      imgName = @get('image_id')
      return unless imgName
      @set 'image_url', "/images/game/emotions/#{imgName}.png"


    # ------------------------------------------------------------------- Event Handlers
    onChangeSize: (model, sz) -> @set 'userChangedSize', true
    onChangePos: (model, pos) -> @set 'userChangedPos', true


    # ------------------------------------------------------------------- Public API
    getScale: ->
      @sizeToScale[ @get('size') ]


  # --------------------------------------------------------------------- Collection
  Collection = Backbone.Collection.extend
    model: Model


  Collection




