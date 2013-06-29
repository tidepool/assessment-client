define [
  'underscore'
  'backbone'
  'Handlebars'
  'game/levels/_base'
  'text!./main.hbs'
  'text!./instructions-simple.hbs'
  'text!./instructions-complex.hbs'
  'composite_views/perch'
], (
  _
  Backbone
  Handlebars
  Level
  tmpl
  instructionsSimple
  instructionsComplex
  perch
) ->

  _me = 'game/levels/reaction_time_disc'
  _colorizerSel = '#CircleColorizer'
  _targetPrequelColor = 'yellow'
  _targetColor = 'red'
  _correctTargetClass = 'target'
  _hitClass = 'hit'
  _animationTime = 750
  _maxDelay = 1500
  _TYPES =
    simple: 'simple'
    complex: 'complex'
  _EVENTS =
    shown: "circle_shown"
    correct: "correct_circle_clicked"
    incorrect: "wrong_circle_clicked"

  ReactionTime = Level.extend
    className: 'reactionTimeDisc'
    events:
      "click #ReactionTimeTarget": "_onCircleClicked"
      "click .target #ReactionTimeTarget": "_onCorrectClick"

    # ------------------------------------------------------------- Backbone Methods
    start: ->
      @stageNo = @options.stageNo
      @assessment = @options.assessment
      @sequenceType = @model.get('sequence_type')
      @colorSequence = @model.get('sequence')
#      console.log seq:@colorSequence
      @sequenceNo = -1
      @numOfSequences = @colorSequence.length
      _.bindAll @, '_showCircle', '_end', '_start'

    render: ->
      instructions = if @sequenceType is _TYPES.simple then instructionsSimple else instructionsComplex
      @$el.html tmpl
      perch.show
        content: instructions
        large: true
        btn1Text: "I'm Ready"
        onClose: @_start
        supressTracking: true
      @


    # ------------------------------------------------------------- Running the Game Level / Stage
    _start: ->
      colorSequenceInString = (color.color + ":" + color.interval for color in @colorSequence)[..]
      @track Level.EVENTS.start,
        color_sequence: colorSequenceInString
      $("#infobox").css("visibility", "hidden")
      @_waitAndShow()

    _showCircle: ->
      @sequenceNo++
      if @sequenceNo < @numOfSequences
        curStep = @colorSequence[@sequenceNo]
        prevStep = @colorSequence[@sequenceNo - 1]
        @track _EVENTS.shown,
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
        if next_seq < @numOfSequences # Still have more circles to show
          @_waitAndShow()
        else if next_seq is @numOfSequences # Currently displaying the last circle
          @_waitAndEnd()

    _waitAndShow: ->
      delay = @colorSequence[@sequenceNo + 1].interval
#      console.log delay:delay
      @step = setTimeout @_showCircle, delay

    _waitAndEnd: ->
      @step = setTimeout @_end, _maxDelay

    _end: ->
      @track Level.EVENTS.end, sequence_no: @sequenceNo
      @assessment.nextStage()


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

    _onCorrectClick: -> $(_colorizerSel).addClass _hitClass


    # ------------------------------------------------------------- User Activity Tracking
    _trackCorrect: ->
      curStep = @colorSequence[@sequenceNo]
      return if curStep.alreadyTracked
      @track _EVENTS.correct,
        circle_color: curStep.color
        sequence_no: @sequenceNo
      curStep.alreadyTracked = true

    _trackIncorrect: ->
      @track _EVENTS.incorrect,
        circle_color: @colorSequence[@sequenceNo]?.color
        sequence_no: @sequenceNo

    # ------------------------------------------------------------- Consumable API
    close: ->
      clearTimeout @step if @step # Prevents the sequence from running if someone navigates away from the game



  ReactionTime