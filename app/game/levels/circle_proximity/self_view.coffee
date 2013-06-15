define [
  'backbone'
  'text!./self.hbs'
],
(
  Backbone
  tmpl
) ->


  # ------------------------------------------------------- Model
  Self = Backbone.Model.extend
    defaults:
      pxSize: 200 # Needed in px for back end processing
      size: 200
      top: 200
      left: 0


  # ------------------------------------------------------- View
  _me = 'game/levels/circle_proximity/self_view'
  View = Backbone.View.extend
    id: 'SelfCircle'
    className: 'self'
    initialize: -> @model = new Self()
    render: ->
      @$el.html tmpl
      @
    _setCssStyling: (data) ->
      @$el.css
        top: data.top
        left: data.left

    _calculateSelfCenter: ->
      @_center =
        x: @$el.parent().width() / 2
        y: @model.get('top') + @getSelfRadius()
      @_center

    # ----------------------------------------------------- Public API
    getSelfCenter: ->
      @_center or @_calculateSelfCenter()
    getSelfRadius: ->
      @_radius or @model.get('pxSize') / 2
    position: ->
      # Figure out how far from the left it should be
      left = @getSelfCenter().x - @model.get('pxSize') / 2
      @model.set left: left
      @_setCssStyling @model.attributes
      @


  View




