
define [
  'backbone'
  'Handlebars'
  './circle_view'
  'text!./sizey_view.hbs'
  'fastclick'
  'jqueryui/slider'

],
(
  Backbone
  Handlebars
  CircleView
  tmpl
  FastClick
  JqSlider
) ->

  _me = 'game/levels/circle_proximity/sizey_view'
  _sliderSel = '.slider'
  _sliderHandleSel = '.ui-slider-handle'
  _circleSel = '.circle'
  _needsNormalClickClass = 'needsclick'

  View = Backbone.View.extend

    # ----------------------------------------------------- Backbone Extensions
    className: 'sizey'
    tmpl: Handlebars.compile tmpl

    initialize: ->
      _.bindAll @, 'onSlide', 'onFocus', 'onClick'
      @circle = new CircleView
        model: @model

    render: ->
      @$el.html @circle.render().el
      @$el.append @tmpl @model.attributes
      @$el.find(_sliderSel).slider
        value: @model.get('size')
        max: @model.maxSize
        slide: @onSlide
      @$(_sliderHandleSel).on 'click', @onClick # Bind after the slider is set up so we can catch clicks on that
      @$(_sliderHandleSel).on 'focus', @onFocus
      @


    # ----------------------------------------------------- Event Callbacks
    onSlide: (e, ui) ->
      @model.set
        size: ui.value
        interacted:true
    onClick: -> @model.set interacted:true
    onFocus: -> @model.set interacted:true

  View




