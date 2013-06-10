
define [
  'backbone'
  'Handlebars'
  './circle_view'
  'text!./slider.hbs'
  'text!./label.hbs'
  'jqueryui/slider'
],
(
  Backbone
  Handlebars
  CircleView
  sliderTmpl
  labelTmpl
  JqSlider
) ->

  _me = 'game/levels/circle_proximity/sizey_view'
  _sliderSel = '.slider'

  View = Backbone.View.extend

    # ----------------------------------------------------- Backbone Extensions
    className: 'sizey'
    labelTmpl: Handlebars.compile labelTmpl
    initialize: ->
      _.bindAll @, 'onSlide'
      @circle = new CircleView
        model: @model

    render: ->
      @$el.html @circle.render().el
      @$el.append sliderTmpl
      @$el.append @labelTmpl @model.attributes
      @$el.find(_sliderSel).slider
        value: @model.get('size')
        max: @model.maxSize
        slide: @onSlide
      @


    # ----------------------------------------------------- Private Methods


    # ----------------------------------------------------- Event Callbacks
    onSlide: (e, ui) ->
      #console.log "#{_me}.onSlide"
      @model.set 'size', ui.value






  View




