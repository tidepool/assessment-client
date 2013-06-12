define [
  'jquery'
  'underscore'
  'backbone'
  'Handlebars'
  'models/user_event'
  "text!./main.hbs"
  'composite_views/perch'
], (
  $
  _
  Backbone
  Handlebars
  UserEvent
  tmpl
  perch
) ->

  _me = 'game/levels/reaction_time_disc'
  _colorizerSel = '#CircleColorizer'
  _targetPrequelColor = 'yellow'
  _targetColor = 'red'
  _correctTargetClass = 'target'
  _hitClass = 'hit'
  _animationTime = 750
  _TYPES =
    simple: 'simple'
    complex: 'complex'
  _USEREVENTS =
    started: "test_started"
    shown: "circle_shown"
    correct: "correct_circle_clicked"
    incorrect: "wrong_circle_clicked"
    completed: "test_completed"


  ReactionTime = Backbone.View.extend

    className: 'reactionTimeDisc'
    tmpl: Handlebars.compile(tmpl)
    events:
      "click #ReactionTimeTarget": "_onCircleClicked"
      "click .target #ReactionTimeTarget": "_onCorrectClick"


    # ------------------------------------------------------------- Backbone Methods
    initialize: (options) ->
      @stageNo = options.stageNo
      @assessment = options.assessment
      # @colors = @model.get('colors')
      @sequenceType = @model.get('sequence_type')
      @colorSequence = @model.get('sequence')
#      console.log step.color for step in @colorSequence
      @sequenceNo = -1
      @numOfSequences = @colorSequence.length

    render: ->
      @$el.html @tmpl()
      perch.show
        msg: @model.get('instructions')
        #onClose: => @_start()
        btn1Text: "I'm Ready"
        btn1Callback: _.bind(@_start, @)
        mustUseButton: true
      @


    # ------------------------------------------------------------- Running the Game Level / Stage
    _start: ->
      colorSequenceInString = (color.color + ":" + color.interval for color in @colorSequence)[..]
      @_createUserEvent
        event_desc: _USEREVENTS.started
        color_sequence: colorSequenceInString
      $("#infobox").css("visibility", "hidden")
      @_waitAndShow()

    _showCircle: ->
      @sequenceNo++
      if @sequenceNo < @numOfSequences
        curStep = @colorSequence[@sequenceNo]
        prevStep = @colorSequence[@sequenceNo - 1]
        @_createUserEvent
          event_desc: _USEREVENTS.shown
          circle_color: curStep.color
          sequence_no: @sequenceNo
          time_interval: curStep.interval
        $(_colorizerSel).prop('class', curStep.color)

        # Add a target class if this is the circle folks are supposed to click on
        if @sequenceType is _TYPES.simple and curStep.color is _targetColor
          $(_colorizerSel).addClass _correctTargetClass
        else if @sequenceType is _TYPES.complex and curStep.color is _targetColor and prevStep?.color is _targetPrequelColor
          $(_colorizerSel).addClass _correctTargetClass

        next_seq = @sequenceNo + 1
        if next_seq < @numOfSequences
          @_waitAndShow()

    _waitAndShow: ->
      delay = @colorSequence[@sequenceNo + 1].interval
      setTimeout _.bind(@_showCircle, @), delay



    # ------------------------------------------------------------- Event Handlers
    _onCircleClicked: (e) ->
      e.preventDefault()
      curStep = @colorSequence[@sequenceNo]
      prevStep = @colorSequence[@sequenceNo - 1]
      if @sequenceNo <= 0
        @_trackIncorrect()
      else if @sequenceType is _TYPES.simple and curStep.color is _targetColor
        @_trackCorrect()
      else if @sequenceType is _TYPES.complex and curStep.color is _targetColor and prevStep.color is _targetPrequelColor
        @_trackCorrect()
      else
        @_trackIncorrect()

    _onCorrectClick: ->
      $(_colorizerSel).addClass _hitClass
      # Exit the test if that was the last circle
      if (@sequenceNo is @numOfSequences - 1)
        @_createUserEvent
          event_desc: _USEREVENTS.completed
          sequence_no: @sequenceNo
        setTimeout _.bind(@assessment.nextStage, @assessment), _animationTime


    # ------------------------------------------------------------- User Activity Tracking
    _trackCorrect: ->
      curStep = @colorSequence[@sequenceNo]
      return if curStep.alreadyTracked
      #console.log("#{_me}._trackCorrect()")
      @_createUserEvent
        event_desc: _USEREVENTS.correct
        circle_color: curStep.color
        sequence_no: @sequenceNo
      curStep.alreadyTracked = true

    _trackIncorrect: ->
      #console.log("#{_me}._trackIncorrect()")
      @_createUserEvent
        event_desc: _USEREVENTS.incorrect
        circle_color: @colorSequence[@sequenceNo]?.color
        sequence_no: @sequenceNo

    _createUserEvent: (newEvent) ->
      eventInfo = 
        game_id: @assessment.get('id')
        module: "reaction_time"
        stage: @stageNo
        sequence_type: @sequenceType
      fullInfo = _.extend({}, eventInfo, newEvent)
      userEvent = new UserEvent()
      userEvent.send(fullInfo)




  ReactionTime