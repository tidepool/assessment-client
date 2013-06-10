define [
  'backbone'
],
(
  Backbone
) ->

  _me = 'game/levels/circle_proximity/circle_view'
  View = Backbone.View.extend

    # ----------------------------------------------------- Backbone Extensions
    className: 'circle'
    initialize: ->
      @listenTo @model, 'change:size', @onChangeSize
    render: ->
      @$el.html @model.get 'abbreviation'
      @setClassBySize @model.get 'size'
      @


    # ----------------------------------------------------- Private Methods


    # ----------------------------------------------------- Event Callbacks
    onChangeSize: (model, newSize) ->
      @setClassBySize newSize

    # ----------------------------------------------------- Public API
    removeSizeClass: ->
      @$el.removeClass(size) for size in @model.sizeToClass
    setClassBySize: (size) ->
      @removeSizeClass()
      @$el.addClass @model.sizeToClass[size]



  View




