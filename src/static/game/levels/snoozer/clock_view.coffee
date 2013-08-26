define [
  'underscore'
  'backbone'
  'Handlebars'
], (
  _
  Backbone
  Handlebars
) ->

  _defaultDuration = 1000
  _fallTime = 150 # Time to fall back to a resting position
  _feedbackTime = 500 # Time to show the user good or bad click feedback
  CLASSES =
    ring: 'ringing'
    decoy: 'decoy'
    float: 'float'
    hitGood: 'yay'
    hitBad: 'boo'
  _markup = '<b class="clock"></b>'

  View = Backbone.View.extend
    className: 'clockHolder'
    events: click: 'onClick'

    # ------------------------------------------------------------- Backbone Methods
    initialize: ->
      throw new Error "Need options.daddy" unless @options.daddy
      _.bindAll @, 'miss', '_stopRing'

    render: ->
      @$el.html _markup
      @

    _reset: ->
      @ringTime = new Date()
      @$el.prop 'class', @className # reset to defaults
      @model.clear().set @model.defaults
    _clearTimeout: -> clearTimeout @timeout

    # Because this object only plans one step ahead, funelling all timers through here makes setTimeout cleanup simpler
    _upNext: (action, delay) ->
      clearTimeout @timeout # Won't throw error if timeout doesn't exist, and that's good.
      @timeout = setTimeout action, delay

    _stopRing: ->
      @_reset()
      @_upNext (=> @isRinging = false), _fallTime


    # ------------------------------------------------------------- User Action Handlers
    correct: ->
      @model.set reaction_time: (new Date()) - @ringTime
      @options.daddy.trigger 'correct', @model
      @$el.addClass CLASSES.hitGood
      @_upNext @_stopRing, _feedbackTime

    incorrect: ->
      @options.daddy.trigger 'incorrect', @model
#      @_reset()
      @$el.addClass CLASSES.hitBad
      @_upNext @_stopRing, _feedbackTime

    miss: ->
      @model.set reaction_time: (new Date()) - @ringTime
      @options.daddy.trigger('miss', @model) unless @$el.hasClass CLASSES.decoy
      @_stopRing()


    # ------------------------------------------------------------- Event Handlers
    onClick: (e) ->
      @_clearTimeout()
      if @$el.hasClass CLASSES.decoy
        @incorrect()
      else if @$el.hasClass CLASSES.ring
        @correct()
      else
        @incorrect()


    # ------------------------------------------------------------- User Activity Tracking



    # ------------------------------------------------------------- Consumable API
    ring: (duration, isDecoy) ->
      @_reset()
      duration = duration || _defaultDuration
      @model.set
        duration: duration
        isDecoy: isDecoy || false
      unless isDecoy
        @options.daddy.trigger 'ring', @model
      else
        @options.daddy.trigger 'decoy', @model
      @$el.addClass CLASSES.ring
      @$el.addClass CLASSES.float
      @$el.addClass CLASSES.decoy if isDecoy
      @isRinging = true
      @_upNext @miss, duration






  View