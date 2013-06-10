define [
  'underscore'
  'backbone'
  './circles'
  './sizey_view'
  './circle_draggable_view'
  './proxy_view'
  'composite_views/perch'
  'models/user_event'
  'ui_widgets/proceed'
  './self_view'
],
(
  _
  Backbone
  Circles
  Sizey
  CircleDraggable
  Proxy
  perch
  UserEvent
  proceed
  SelfView
) ->

  _me = 'game/levels/circle_proximity/main'
  _researchModuleName = 'circles_test'
  _USEREVENTS =
    started: "test_started"
    completed: "test_completed"


  View = Backbone.View.extend

  # ----------------------------------------------------- Backbone Extensions
    className: 'circleProximity'

    initialize: ->
      #@collection = new RankableImages @model.get('image_sequence')
      @collection = new Circles @model.get('circles')
      @listenTo @collection, 'change:userChangedSize', @onChangeUserChangedSize
      @listenTo @collection, 'change:userChangedPos', @onChangeUserChangedPos
      @listenTo proceed, 'click', @onProceedClick
      _.bindAll @, '_showSizingSublevel', '_showProximitySublevel'
      @render()
      #@_trackStart()

    render: ->
      #@$el.html tmpl

      #TODO: remove. This is just starting on sub level 2 for quicker dev
#      size = 0
#      @collection.each (circle) =>
#        circle.set 'size', size++
#      @_showProximityInstructions()
      @_showSizingInstructions()
      @


    # ----------------------------------------------------- Private Methods, Sizing Sublevel
    _showSizingInstructions: ->
      msg = @model.get('instructions')[0]
      perch.show
        msg: msg
        btn1Text: "I'm Ready"
        btn1Callback: @_showSizingSublevel
        mustUseButton: true
      @

    _showSizingSublevel: ->
      #console.log "#{_me}._showSizingSublevel()"
      # For each circle, make it a new sizey view that has a reference to the circle
      @collection.each (circle) =>
        circle.view = new Sizey
          model: circle
        @$el.append circle.view.render().el
        circle.calculateWidth()

    _checkSizingDone: ->
      # Ready to proceed if the user changed all the circle sizes
      changedCircles = @collection.filter (circle) -> circle.get('userChangedSize')
      if changedCircles.length is @collection.length - 1
        return true

    _finishSizingSublevel: ->
      @collection.each (circle) => circle.view.remove() # Removing one at a time lets views clean up their events
      @_showProximityInstructions()


    # ----------------------------------------------------- Private Methods, Proximity Sublevel
    _showProximityInstructions: ->
      msg = @model.get('instructions')[1]
      perch.show
        msg: msg
        btn1Text: "I'm Ready"
        btn1Callback: @_showProximitySublevel
        mustUseButton: true
      @

    _showProximitySublevel: ->
      console.log "#{_me}._showProximitySublevel()"
      self = new SelfView()
      @$el.html self.render().el
      self.position() #position has to be called after the element is in the dom
      @_setInitialCirclePositions()
      @collection.each (circle) =>
        circle.view = new CircleDraggable
          model: circle
        circle.proxy = new Proxy
          model: circle
        @$el.append circle.view.render().el
        @$el.append circle.proxy.render().el
        circle.proxy.position()
        circle.view.makeDraggable()

    _setInitialCirclePositions: ->
      # Calculate the Initial position of each circle on the stage
      left = 0
      top = -150
      @collection.each (circle) =>
        circle.set 'pos',
          x: left += 200
          y: Math.abs( top += 50 )
        # Figure out what degree to start on
        # How many degrees to skip each time
        # get the self circle's center position
        # get the distance away each circle should be
        # selfPos selfRadius buffer circleRadius circlePos
        # calculate circle pos relative to self circle
        # map to parent coords`

    _checkProximityDone: ->
      changedCircles = @collection.filter (circle) -> circle.get('userChangedPos')
      if changedCircles.length is @collection.length
        return true


    # ----------------------------------------------------- Event Handlers
    onProceedClick: ->
      proceed.hide()
      if @_checkSizingDone() and @_checkProximityDone()
        #@_completeLevel()
      else if @_checkSizingDone()
        @_finishSizingSublevel()

    onChangeUserChangedSize: ->
      proceed.show() if @_checkSizingDone()
#    onCircleDropped: (e) ->
#      console.log "#{_me}.onCircleDropped"
    onChangeUserChangedPos: ->
      console.log "#{_me}.onChangeUserChangedPos"


    # ----------------------------------------------------- User Event Tracking
#    _trackUserEvent: (newEvent) ->
#      eventInfo =
#        assessment_id: @options.assessment.get('id')
#        module: _researchModuleName
#        stage: @options.stageNo
#      userEvent = new UserEvent()
#      userEvent.send _.extend(eventInfo, newEvent)
#    _trackStart: ->
#      @_trackUserEvent
#        event_desc: _USEREVENTS.started
#        image_sequence: @collection.toJSON()
#    _trackRanked: (id, newRank) ->
#      @_trackUserEvent
#        image_no: id
#        rank: newRank
#        event_desc: _USEREVENTS.ranked
#    _trackRankCleared: (id, oldRank) ->
#      @_trackUserEvent
#        image_no: id
#        rank: oldRank
#        event_desc: _USEREVENTS.unranked
#    _trackDragged: (id) ->
#      @_trackUserEvent
#        image_no: id
#        event_desc: _USEREVENTS.dragged
#    _trackEnd: ->
#      @_trackUserEvent
#        event_desc: _USEREVENTS.completed

  View


