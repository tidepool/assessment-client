define [
  'backbone'
  './self'
  'text!./self.hbs'
],
(
  Backbone
  Self
  tmpl
) ->

  _me = 'game/levels/circle_proximity/self_view'

  View = Backbone.View.extend

    # ----------------------------------------------------- Backbone Extensions
    className: 'self'
    initialize: ->
      @model = new Self()
    render: ->
      @$el.html tmpl
      @


    # ----------------------------------------------------- Private Methods
    _setCssStyling: (data) ->
      @$el.css
        top: data.top
        left: data.left
        width: data.pxSize
        height: data.pxSize
        'line-height': data.pxSize



    # ----------------------------------------------------- Event Callbacks

    # ----------------------------------------------------- Public API
    position: ->
      # Figure out how far from the left it should be
      left = @$el.parent().width() / 2 - @model.get('pxSize') / 2
      @model.set
        left: left
      @_setCssStyling @model.attributes
      @


  View




