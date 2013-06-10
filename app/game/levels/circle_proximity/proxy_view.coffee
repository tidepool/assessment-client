define [
  'underscore'
  'backbone'
  'Handlebars'
  'text!./label.hbs'
],
(
  _
  Backbone
  Handlebars
  labelTmpl
) ->

  _me = 'game/levels/circle_proximity/proxy_view'
  _lineMarkup = '<div class="line"><b class="dot"></b></div>'
  _spaceTiny = 3

  View = Backbone.View.extend

    # ----------------------------------------------------- Backbone Extensions
    className: 'proxy'
    labelTmpl : Handlebars.compile labelTmpl
    initialize: ->

    render: ->
      @$el.html @labelTmpl @model.attributes
      @model.$line = $(_lineMarkup)
      @model.$label = @$('label')
      @$el.append @model.$line
      @


    # ----------------------------------------------------- Private Methods
    _positionLabelByCircle: (circle) ->
      #console.log "#{_me}._positionLabelByCircle"
      console.log circle
      size = circle.width
      @$el.css
        top: circle.top + size + _spaceTiny
        left: circle.left - @$el.width()/2 + size/2
    _positionLineAtCircleCenter: (circle) ->
      size = circle.width
      @model.$line.css
        top: -size/2 - _spaceTiny
        left: @$el.width()/2


    # ----------------------------------------------------- Event Callbacks


    # ----------------------------------------------------- Public API
    position: ->
      @_positionLabelByCircle @model.attributes
      @_positionLineAtCircleCenter @model.attributes



  View




