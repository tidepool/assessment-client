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
      @$el.empty()
      if @collection?
        @collection.each (question) =>
          slippy = new IconSlider model: question
          @$el.append slippy.render().el
          @listenTo slippy, 'slide', @onSlide
          @listenTo slippy, 'stop', @onStop
      return this

    _setDataForServer: ->
      @finalEventData =
        questions: @collection.toJSON()


    # ----------------------------------------------------- Event Handlers
    onSlide: (data) ->
      @track Level.EVENTS.interact,
        question_id: data.model.attributes.question_id
        question_topic: data.model.attributes.question_topic
        answer: data.value

    onStop: (data) ->
      data.model.set 'interacted': true
      data.model.set 'answer', data.value
      @track Level.EVENTS.change,
        question_id:     data.model.attributes.question_id
        question_topic:  data.model.attributes.question_topic
        answer:          data.model.attributes.answer
      @readyToProceed() if @checkAllInteracted @collection
      @_setDataForServer()



  View

