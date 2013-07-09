
define [
  'backbone'
  'Handlebars'
  './circle_view'
  'text!./sizey_view.hbs'
  'jqueryui/slider'
],
(
  Backbone
  Handlebars
  CircleView
  tmpl
  JqSlider
) ->

  _me = 'game/levels/circle_proximity/sizey_view'
  _sliderSel = '.slider'
  _circleSel = '.circle'

  View = Backbone.View.extend

    # ----------------------------------------------------- Backbone Extensions
    className: 'sizey'
    tmpl: Handlebars.compile tmpl
    initialize: ->
      _.bindAll @, 'onSlide'
      @circle = new CircleView
        model: @model

    render: ->
      @$el.html @circle.render().el
      @$el.append @tmpl @model.attributes
      @$el.find(_sliderSel).slider
        value: @model.get('size')
        max: @model.maxSize
        slide: @onSlide
      @


    # ----------------------------------------------------- Event Callbacks
    onSlide: (e, ui) -> @model.set size: ui.value


  View




