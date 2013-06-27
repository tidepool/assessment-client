define [
  'underscore'
  'backbone'
  'game/levels/_base'
  'ui_widgets/icon_slider'
],
(
  _
  Backbone
  Level
  IconSlider
) ->

  _me = 'game/levels/alex_trebek'


  View = Level.extend

    # ----------------------------------------------------- Backbone Extensions
    className: 'alexTrebek'

    render: ->
      console.log "#{_me}.render()"
      @$el.empty()
      if @collection?
        @collection.each (question) =>
          slippy = new IconSlider model: question
          @$el.append slippy.render().el
          @listenTo slippy, 'slide', @onSlide
          @listenTo slippy, 'stop', @onStop
      return this


    # ----------------------------------------------------- Event Handlers
    onSlide: (data) ->
      @track Level.EVENTS.interact,
        item_id: data.model.attributes.item_id
        item_topic: data.model.attributes.item_topic
        item_value: data.value

    onStop: (data) ->
      data.model.set 'interacted': true
      @track Level.EVENTS.change,
        item_id: data.model.attributes.item_id
        item_topic: data.model.attributes.item_topic
        item_value: data.value
      @readyToProceed() if @checkAllInteracted @collection



  View

