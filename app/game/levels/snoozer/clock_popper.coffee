define [
  'underscore'
  'backbone'
  'Handlebars'
  'text!./stage.hbs'
  './clock_view'
  './clock'
  './summary'
], (
  _
  Backbone
  Handlebars
  stage
  ClockView
  Clock
  Summary
) ->

  _stageSel = '.stage'
  _slowSteps = 3 # Show the first N steps as 'slow', for training purposes
  _defaultOptions =
    clockCount: 5
    stepLimit: 10 #5
    pauseTime: 1000 # Pauses before starting, and between difficult levels
    durationMax: 1600 # How long to show the clock ringing
    durationMin: 1100
  _flipCoin = -> Math.floor(Math.random()*2)

  EVENTS =
    shown: 'circle_shown'
    decoy: 'decoy'
    miss: 'miss'
    correct: 'correct_circle_clicked'
    incorrect: 'wrong_circle_clicked'


  View = Backbone.View.extend
    className: 'clockPopper'

    # ------------------------------------------------------------- Backbone Methods
    initialize: (options) ->
      throw new Error "Need options.level" unless @options.level
      @options = _.extend _defaultOptions, options
      @clocks = []
      for i in [0...@options.clockCount]
        model = new Clock
#          id: i
        @clocks.push new ClockView
          daddy: @
          model: model

      _.bindAll @, 'ringOne', '_goSlow', '_goFast', '_done'
      @on 'ring', @onRing
      @on 'decoy', @onDecoy
      @on 'miss', @onMiss
      @on 'correct', @onCorrect
      @on 'incorrect', @onIncorrect

    render: ->
      @$el.html stage
      for clock in @clocks
        @$(_stageSel).append clock.render().el
      @step = 0
      if @options.complex # The slow prequel is not necessary for the complex version of the game
        @_goFast true
      else
        @options.stepLimit -= _slowSteps
        @_goSlow true
      @


    # ------------------------------------------------------------- Clock Events
    onRing: (clock) ->
      @options.level.summary.increment 'total'
      @options.level.track EVENTS.shown, clock.attributes
    onDecoy: (clock) ->
      @options.level.summary.increment 'decoys'
      @options.level.track EVENTS.decoy, clock.attributes
    onMiss: (clock) ->
      @options.level.summary.increment 'missed'
      @options.level.track EVENTS.miss, clock.attributes
    onCorrect: (clock) ->
      @options.level.summary.increment 'correct'
      @options.level.summary.addTime clock.attributes.reaction_time
      @options.level.track EVENTS.correct, clock.attributes
    onIncorrect: (clock) ->
      @options.level.summary.increment 'incorrect'
      @options.level.track EVENTS.incorrect, clock.attributes


    # ------------------------------------------------------------- Clock Management
    # get a random clock from the set, but not one that's already ringing
    _getRandomClock: ->
      clock = @clocks[ Math.floor( Math.random() * @clocks.length ) ]
      # Keep trying until we get a clock that isn't ringing
      if clock.isRinging
#        console.log "already ringing, trying again"
        @_getRandomClock()
      else
        clock

    _done: (playFast) ->
      if playFast is true
        @step = 0
        @_goFast true
      else
        setTimeout (=> @options.level.next()), @options.pauseTime

    _goSlow: (wait) ->
      if wait is true
        setTimeout @_goSlow, @options.pauseTime
      else if @step >= _slowSteps
        @_done true
      else
        @step++
#        console.log step:@step
        duration = @ringOne()
        wait = _.random @options.durationMin/2, @options.durationMax/2
        setTimeout @_goSlow, duration + wait

    _goFast: (wait) ->
      if wait is true
#        console.log 'goFast with wait:true'
        setTimeout @_goFast, @options.pauseTime
      else if @step >= @options.stepLimit
#        console.log 'goFast hit step limit'
        do @_done
      else
        @step++
#        longestDur = @ringBunches()
#        console.log longestDuration:longestDur
        duration = @ringOne()
        #        wait = _.random @options.durationMin/2, @options.durationMax/2
        setTimeout @_goFast, duration / 2

    ringOne: (delay) ->
      duration = _.random @options.durationMin, @options.durationMax
      clock = @_getRandomClock()
      # Tell the clock to jump and for how long (how high we'll leave up to the clock).
      # Clock records its own press or miss events
      if delay
        setTimeout (-> clock.ring duration), delay
      else
        if @options.complex and _flipCoin()
          clock.ring duration, true # Show a decoy clock, but don't count it towards the total clocks
          @step--
        else
          clock.ring duration
      duration


  View
