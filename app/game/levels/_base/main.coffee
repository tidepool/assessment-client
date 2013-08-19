define [
  'jquery'
  'underscore'
  'backbone'
  'entities/user_event/_event_bundle'
  'composite_views/perch'
  'ui_widgets/proceed'
],
(
  $
  _
  Backbone
  EventBundle
  perch
  proceed
) ->

  _me = 'game/levels/_base'


  Export = Backbone.View.extend

    # ----------------------------------------------------- Backbone Extensions
    initialize: ->
      throw new Error "Need assessment and stageNo and stageDef" unless @options.assessment? and @options.stageNo? and @options.stageDef?
      @event = new EventBundle
        event_type: @options.stageDef
        stage: @options.stageNo
        game_id: @options.assessment.get 'id'
      if @model.attributes.data?
        if @CollectionClass
          @collection = new @CollectionClass @model.attributes.data
        else
          @collection = new Backbone.Collection @model.attributes.data
      if typeof @start is "function"
        @start() # Call the extending level's start method, if it has impelemented one
      else
        @track EventBundle.EVENTS.start


    # ------------------------------------------------------------- Private Methods
    _fillHeight: ->
      @$el.css height: @getAvailHeight()


    # ------------------------------------------------------------- Consumable API
    # Clear `interacted` flag on each item in a collection. Useful if a collection is used in multiple levels
    clearInteracted: (collection) ->
      collection.each (item) -> item.set 'interacted', null

    # Check the whole collection for an `interacted` property. Return true if they all are.
    checkAllInteracted: (collection) ->
      interacted = collection.filter (item) -> item.get('interacted')
      return true if interacted.length is collection.length

    readyToProceed: ->
      return if @alreadyReady
      @alreadyReady = true
      proceed.show()
      @listenToOnce proceed, 'click', @endLevel
      @track EventBundle.EVENTS.readyToProceed

    notReadyToProceed: ->
      return if not @alreadyReady
      @alreadyReady = false
      proceed.hide()
      @stopListening proceed
      @track EventBundle.EVENTS.notReadyToProceed

    endLevel: ->
      proceed.hide()
      # Send level summary
      @track EventBundle.EVENTS.summary, @summaryData
      # Send level end event
      @track EventBundle.EVENTS.end#, @endData
      @event.save()
      @trigger 'done', @summaryData
      @close?() # Call the mixed-in level's close method, if it has implemented one
      @remove()
      @options.assessment.nextStage()

    track: (eventName, eventData) ->
      baseData =
        event: eventName
      @event.record _.extend baseData, eventData

    getAvailHeight: ->
      availHeight = $(window).height() - @$el.offset().top
      availHeight -= @heightAdjustment if @heightAdjustment
#      console.log
#        offset: @$el.offset().top
#        windowHeight: $(window).height()
#        availHeight: availHeight
      availHeight

    # Fill the height to what is available, and continue to do so if the window size changes
    fillHeight: ->
      @_fillHeight()
      debounced = _.debounce @_fillHeight, 100
      $(window).on 'resize', _.bind debounced, @


    remove: ->
      @close?()
      $(window).off 'resize'
      proceed.hide()
      @$el.remove()
      @stopListening()
      return this

  Export.EVENTS = EventBundle.EVENTS
  Export

