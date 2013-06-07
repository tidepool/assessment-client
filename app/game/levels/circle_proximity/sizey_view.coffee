
define [
  'backbone'
  'Handlebars'
  './circle_view'
  'text!./slider.hbs'
  'jqueryui/slider'
],
(
  Backbone
  Handlebars
  CircleView
  sliderTmpl
  JqSlider
) ->

  _me = 'game/levels/circle_proximity/sizey_view'
  _sliderMarkup = '<div class="slider"></div>'
  _maxSize = 10

  View = CircleView.extend

    # ----------------------------------------------------- Backbone Extensions
    className: 'sizey'
    sliderTmpl: Handlebars.compile sliderTmpl
    # initialize: -> #_.bindAll @, 'onSlide'

    render: ->
      @$el.html @circleTmpl @model.attributes
      @slider = $(_sliderMarkup).slider
        value: @model.get('size')
        max: _maxSize
        slide: @onSlide
      @$el.append @slider
      return this







      # ----------------------------------------------------- Private Methods


      # ----------------------------------------------------- Event Callbacks
      onSlide: -> console.log "#{_me}.onSlide"


  View




