define [
  'underscore'
  'backbone'
#  'Handlebars'
#  'text!./main.hbs'
  './circles'
  './sizey_view'
  './proxy_view'
  'composite_views/perch'
  'models/user_event'
  'ui_widgets/proceed'
],
(
  _
  Backbone
#  Handlebars
#  tmpl
  Circles
  Sizey
  Proxy
  perch
  UserEvent
  Sortable
  proceed
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
      @collection = new Circles @model.get 'circles'
      _.bindAll @, '_showSizingSublevel', '_showProximitySublevel'
      @render()
      #@_trackStart()

    render: ->
      #@$el.html tmpl
      @_showSizingInstructions()


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
      console.log "#{_me}._showSizingSublevel()"
      # For each circle, make it a new sizey view that has a reference to the circle
      @collection.each (circle) =>
        circle.view = new Sizey
          model: circle
        @$el.append circle.view.render().el


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


    # ----------------------------------------------------- Event Handlers
    onCircleDragged: (e) ->
      console.log "#{_me}.onCircleDragged()"
    onCircleDropped: (e) ->
      console.log "#{_me}.onCircleDropped()"
    onCircleClicked: (e) ->
      console.log "#{_me}.onCircleClicked()"


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


