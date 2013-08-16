define [
  'Handlebars'
  'game/levels/circle_proximity/proxy_view'
  'text!./circle_view.hbs'
  'game/levels/_base'
],
(
  Handlebars
  CircleProximityCircleView
  tmpl
  Level
) ->

  _freshClass = 'fresh'

  View = CircleProximityCircleView.extend

    # ----------------------------------------------------- Class Extensions
    tmpl: Handlebars.compile tmpl
    className: "circleHolder #{_freshClass}"

    # ----------------------------------------------------- Private Methods



    # ----------------------------------------------------- Draggable Events

    onDragStart: (e, ui) ->
      @$el.removeClass _freshClass
      @options.track Level.EVENTS.moveStart,
        index: @model.collection.indexOf @model
        item: @model.toJSON()

    onDrag: (e, ui) ->
      @_maintainLine(e, ui)

    onDragStop: (e, ui) ->
#      @_updateModelPosition() #TODO: fix. Maybe @$el.trigger 'focus'
      @options.track Level.EVENTS.moveEnd,
        index: @model.collection.indexOf @model
        item: @model.toJSON()


    # ----------------------------------------------------- UI Events



    # ----------------------------------------------------- Consumable API


  View

