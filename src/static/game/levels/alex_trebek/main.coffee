define [
  'underscore'
  'backbone'
  'game/levels/_base'
  'ui_widgets/icon_slider'
  'ui_widgets/formation/select_by_icon'
],
(
  _
  Backbone
  Level
  IconSlider
  SelectByIcon
) ->

  _me = 'game/levels/alex_trebek'
  TYPES =
    icon_slider: 'icon_slider'
    select_by_icon: 'select_by_icon'
  TYPEVIEWS =
    icon_slider: IconSlider
    select_by_icon: SelectByIcon

  View = Level.extend

    # ----------------------------------------------------- Backbone Extensions
    className: 'alexTrebek'

    render: ->
      @$el.empty()
      if @collection?
        @collection.each (question) => @_renderOneQuestion question
      @

    _renderOneQuestion: (question) ->
      type = question.attributes.question_type
#      console.log question:question
      # Render it if it's a known type
      if TYPEVIEWS[type]
        questionView = new TYPEVIEWS[type] model:question
        @$el.append questionView.render().el
        # Do special behavior based on the question type
        switch type
          when TYPES.icon_slider
            @listenTo questionView, 'slide', @onSlide
            @listenTo questionView, 'stop', @onChange
          when TYPES.select_by_icon
            @listenTo questionView, 'change', @onChange
#          else
#            console.log "#{type} has no special behavior, and that's OK"
      else
        console.warn "#{type} is not a known question type"

    _setDataForServer: -> @summaryData = data: @collection.toJSON()


    # ----------------------------------------------------- Event Handlers
    onSlide: (data) ->
      @track Level.EVENTS.interact, data.model.attributes

    onChange: (data) ->
      data.model.set 'interacted': true
      data.model.set 'answer', data.value
      @track Level.EVENTS.change, data.model.attributes
      @readyToProceed() if @checkAllInteracted @collection
      @_setDataForServer()


  View

