
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


  View = Backbone.View.extend

    # ----------------------------------------------------- Backbone Extensions
    className: 'sizey'
    sliderTmpl: Handlebars.compile sliderTmpl
    initialize: ->
      _.bindAll @, 'onSlide'
      @circle = new CircleView
        model: @model

    render: ->
      @$el.html @circle.render().el
      @slider = $(_sliderMarkup).slider
        value: @model.get('size')
        min: @model.minSize
        max: @model.maxSize
        slide: @onSlide
      @$el.append @slider
      @







    # ----------------------------------------------------- Private Methods
#    _setCircleSize: (newSize) ->
#      $circle = @$el.find '.circle'
#      $circle.removeProp 'class'
#      @$el.addClass "circle #{_SIZES[newSize]}"
#      debugger


    # ----------------------------------------------------- Event Callbacks
    onSlide: (e, ui) ->
      #console.log "#{_me}.onSlide"
      @model.set 'size', ui.value




  View




