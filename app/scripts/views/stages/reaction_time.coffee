define [
  'jquery'
  'underscore'
  'backbone'
  'Handlebars'
  'models/user_event'
  "text!./reaction_time.hbs"
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

  _me = 'stages/reaction_time'
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

    className: 'stage-reactionTime'
    tmpl: Handlebars.compile(tmpl)
    events:
      "click #ReactionTimeTarget": "_onCircleClicked"
      "click .target #ReactionTimeTarget": "_onCorrectClick"


    # ------------------------------------------------------------- Backbone Methods
    initialize: (options) ->
      @stageNo = options.stageNo
      @assessment = options.assessment
      @colors = @model.get('colors')
      @sequenceType = @model.get('sequence_type')
      @colorSequence = @prepareSequence()

      # Log out the colors. Why does red show up twice in a row sometimes?
      console.log @colorSequence
      console.log step.color for step in @colorSequence

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


    # ------------------------------------------------------------- Game Level Data Preparation
    prepareSequence: ->
      numberOfReds = parseInt @model.get('number_of_reds')
      intervalFloor = parseInt @model.get('interval_floor')
      intervalCeil = parseInt @model.get('interval_ceil')
      limitTo = parseInt @model.get('limit_to')
      max = @colors.length - 1
      min = 0
      redCount = 0
      yellowCount = 0
      count = 0
      sequence = []
      exit = false
      priorColor = null
      
      # TODO: Refactor this!
      while (not exit)
        timeInterval = Math.floor(Math.random() * (intervalCeil - intervalFloor + 1) + intervalFloor)
        outcome = Math.floor(Math.random() * (max - min + 1) + min)
        switch @sequenceType
          when _TYPES.simple
            color = @colors[outcome]
            if color is _targetColor
              redCount += 1
            if redCount > numberOfReds or count > limitTo
              # Always force the last one to be red
              exit = true
              color = _targetColor
            sequence[count] = { color: color, interval: timeInterval } 
          when _TYPES.complex
            if @colors[outcome] is _targetPrequelColor
              yellowCount +=1
            priorColor = sequence[count - 1].color if count > 0
            sequence[count] = { color: @colors[outcome], interval: timeInterval } 
            if @colors[outcome] is _targetColor and priorColor is _targetPrequelColor
              exit = true
            else if yellowCount is 3 and @colors[outcome] is _targetPrequelColor
              # Force the red outcome if there are already 3 yellows
              exit = true
              count += 1
              timeInterval = Math.floor(Math.random() * (intervalCeil - intervalFloor + 1) + intervalFloor)
              sequence[count] = { color: _targetColor, interval: timeInterval }
            else if count > limitTo - 1
              # force read after yellow after the limit is reached
              exit = true
              sequence[count] = { color: _targetPrequelColor, interval: timeInterval }
              timeInterval = Math.floor(Math.random() * (intervalCeil - intervalFloor + 1) + intervalFloor)
              sequence[count + 1] = { color: _targetColor, interval: timeInterval }
        count += 1

      sequence


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
        assessment_id: @assessment.get('id')
        module: "reaction_time"
        stage: @stageNo
        sequence_type: @sequenceType
      fullInfo = _.extend({}, eventInfo, newEvent)
      userEvent = new UserEvent()
      userEvent.send(fullInfo)




  ReactionTime