define [
  'backbone'
  'Handlebars'
  'text!./rankable_image_view.hbs'
  'jqueryui/draggable'
],
(
  Backbone
  Handlebars
  tmpl
  Draggable
) ->

  _me = 'game/levels/rank_images/rankable_image_view'
  _parentSel = '.rankImages'
  _targetSel = '.dropTarget'

  View = Backbone.View.extend

    # ----------------------------------------------------- Backbone Extensions
    tmpl: Handlebars.compile tmpl
    className: 'rankableImage'

    initialize: ->
    render: ->
      @$el.html @tmpl @model.attributes
      @_makeDraggable()
      @


    # ----------------------------------------------------- Private Methods
    _makeDraggable: ->
      # http://jqueryui.com/draggable
      @$el.draggable
        stack: "#{_parentSel} .rankableImage"
        #revert: true
    _bindEvents: ->
#      @listenTo @draggie, 'dragStart', @onDragStart
#      @listenTo @draggie, 'dragMove', @onDragMove
#      @listenTo @draggie, 'dragEnd', @onDragEnd


    # ----------------------------------------------------- Event Callbacks
    onDragStart: -> console.log "#{_me}.onDragStart()"
    onDragMove: -> console.log "#{_me}.onDragMove()"
    onDragEnd: ->
      console.log "#{_me}.onDragEnd()"
      #If we're over a target, snap it into place and change the state of the target




  View




