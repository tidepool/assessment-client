define [
  'backbone'
  'Handlebars'
  'text!./circle.hbs'
],
(
  Backbone
  Handlebars
  tmpl
) ->

  _me = 'game/levels/circle_proximity/circle_view'
  _className = '.circle'
  _SIZES =
    1: 'size1'
    2: 'size2'
    3: 'size3'
    4: 'size4'
    5: 'size5'

  View = Backbone.View.extend

    # ----------------------------------------------------- Backbone Extensions
    tmpl: Handlebars.compile tmpl
    initialize: ->
      @listenTo @model, 'change:size', @onChangeSize
    render: ->
      @$el.html @tmpl @model.attributes
      @

    # ----------------------------------------------------- Private Methods
    _setClassBySize: (newSize) ->
      $circle = @$el.find _className
      $circle.removeClass(size) for key, size of _SIZES
      $circle.addClass _SIZES[newSize]

    # ----------------------------------------------------- Event Callbacks
    onChangeSize: (model, newSize) ->
      @_setClassBySize newSize


  View




