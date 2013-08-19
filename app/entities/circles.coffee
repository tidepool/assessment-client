define [
  'underscore'
  'backbone'
  'classes/model'
],
(
  _
  Backbone
  Model
) ->


  # --------------------------------------------------------------------- Model
  _me = 'game/levels/circle_proximity/circles'
  Circle = Model.extend
    maxSize: 4
    baseSizePx: 75
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
#      selfProximityRank: null
      selfOverlapPx: null
      selfOverlapRatio: null
#      image: null # Used if there should be an image in the circle
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
      @_setWidthBySize @get 'size'
      @on 'change:size', @onChangeSize
      @on 'change:pos', @onChangePos
      @on 'change:percentage', @onChangePercentage

    toJSON: (options) ->
#      attrs = _.pluck @attributes, 'left', 'pos', 'selfOverlapPx', 'selfOverlapRatio', 'selfProximityPx', 'size', 'top', 'trait1', 'trait2', 'width'
      attrs = _.clone @attributes
      delete attrs.interacted
      delete attrs.focus
      delete attrs.abbreviation
      delete attrs.userChangedPos
      delete attrs.userChangedSize
      attrs


    # ------------------------------------------------------------------- Private Methods
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

    _setWidthBySize: (size) ->
      @set width: @sizeToScale[size] * @baseSizePx

    _setSizeByPercent: (percent) ->
      # Sizes are in 5 steps
      step = Math.round (percent / 20) + .5 # the .5 shifts it into the middle of the step
      size = step - 1
      @set size:size


    # ------------------------------------------------------------------- Event Handlers
    onChangeSize: (model, sz) ->
      @set
        userChangedSize: true
        interacted: true
      @_setWidthBySize sz

    onChangePos: (model, pos) ->
      @set
        userChangedPos: true
        interacted: true

    onChangePercentage: (model, percent) -> @_setSizeByPercent percent


    # ------------------------------------------------------------------- Public API
    getScale: -> @sizeToScale[ @get('size') ]



  # --------------------------------------------------------------------- Collection
  Collection = Backbone.Collection.extend model: Circle


  Collection




