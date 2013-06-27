define [
  'backbone'
  'Handlebars'
  "text!./icon_slider.hbs"
  'jqueryui/slider'
],
(
  Backbone
  Handlebars
  tmpl
  JqSlider
) ->

  _me = 'ui_widgets/icon_slider'
  _tmpl = Handlebars.compile tmpl
  _sliderSel = '.slider'
  _sliderHandleSel = '.ui-slider-handle'
  _animationTriggerClass = 'yay'

  View = Backbone.View.extend
    className: 'iconSlider'

    initialize: ->
      _.bindAll @, 'onSlide', 'onStop'

    render: ->
      @$el.html _tmpl @model.attributes
      @$(_sliderSel).slider
        min: 1
        max: @model.attributes.steps
        value: 0
        range: 'min'
        slide: @onSlide
        stop: @onStop
      @$(_sliderHandleSel).append "<i class='#{@model.attributes.icon}'></i>"
      return this

    _shimmer: ($el) ->
      return unless $el
      $el.removeClass _animationTriggerClass
      setTimeout =>
        $el.addClass _animationTriggerClass
        , 1 # This delay lets the dom notice and animate the added class

    # ----------------------------------------------------- Event Callbacks
    onSlide: (e, ui) ->
      console.log
        val: ui.value
      @trigger 'slide',
        model: @model
        value: ui.value

    onStop: (e, ui) ->
      @_shimmer $(ui.handle)
      @trigger 'stop',
        model: @model
        value: ui.value


  View

