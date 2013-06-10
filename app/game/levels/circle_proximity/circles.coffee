define [
  'backbone'
],
(
  Backbone
) ->


  # --------------------------------------------------------------------- Model
  _meModel = 'game/levels/circle_proximity/circles Model'
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
      trait1: ''
      trait2: ''
      abbreviation: ''
      size: 2
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
      #TODO: remove this. temp kludge because the data is sending sizes with '5', but the scale is 0-4
      @set 'size', 2 #@get('size') - 1
      @on 'change:size', @onChangeSize
      @on 'change:pos', @onChangePos

    _calcAbbreviation: ->
      t1 = @get('trait1').charAt 0
      t2 = @get('trait2').charAt 0
      abbr = "#{t1}<em>/</em>#{t2}"
      @set 'abbreviation', abbr

    # ------------------------------------------------------------------- Event Handlers
    onChangeSize: (model, sz) ->
      #console.log "#{_meModel}.onChangeSize(): #{sz}"
      @calculateWidth()
      @set 'userChangedSize', true
    onChangePos: (model, pos) ->
      @set
        left: pos.x
        top: pos.y

    # ------------------------------------------------------------------- Public API
    positionToCenter: (position) ->
      centerer = @get('width') / 2
      center =
        x: position.x + centerer
        y: position.y + centerer
    getScale: ->
      @sizeToScale[ @get('size') ]
    calculateWidth: ->
      return if not @view?.circle?
      #console.log "#{_meModel}.calculateWidth(): #{@view.circle.$el.width() * @getScale()}"
      @set 'width', @view.circle.$el.width() * @getScale()



  # --------------------------------------------------------------------- Collection
  _meCollection = 'game/levels/circle_proximity/circles Collection'
  Collection = Backbone.Collection.extend
    model: Model


  Collection




