define [
  'underscore'
  'backbone'
  'Handlebars'
  'game/levels/_base'
  'text!./instructions-simple.hbs'
  'text!./instructions-complex.hbs'
  'text!./score.hbs'
  './clock_popper'
  './summary'
], (
  _
  Backbone
  Handlebars
  Level
  tmplInstructionsSimple
  tmplInstructionsComplex
  tmplScore
  ClockPopper
  Summary
) ->

  _gameBackgroundClass = 'snoozerBackground'
  _tmplInstructionsComplex = Handlebars.compile tmplInstructionsComplex
  _tmplScore = Handlebars.compile tmplScore

  Snoozer = Level.extend
    className: 'snoozer'

    events: 'click #ActionNext': 'next'

    # ------------------------------------------------------------- Backbone Methods
    render: ->
      @curScreen = 0
      @summary = new Summary()
      $('body').addClass _gameBackgroundClass
      @_showScreen @curScreen
      @


    # ------------------------------------------------------------- Backbone Methods
    _parseOptions: (isComplex) ->
      options =
        level:       @
        complex:     isComplex || false
        clockCount:  @model.attributes.target_count || null
        stepLimit:   @model.attributes.limit_to || null
        durationMax: @model.attributes.interval_ceil || null
        durationMin: @model.attributes.interval_floor || null


    # ------------------------------------------------------------- Running the Game Level
    _showScreen: (idx) ->
      @popper?.remove() #clear the clock object if it's around
      switch idx
        # Simple Instructions
        when 0
          @track Level.EVENTS.instructions
          @$el.html tmplInstructionsSimple
        # Simple Mode
        when 1
          @track Level.EVENTS.subLevel, mode:'simple'
          @popper = new ClockPopper @_parseOptions()
          @$el.html @popper.render().el
        # Complex Instructions
        when 2
          @track Level.EVENTS.instructions
          @$el.html _tmplInstructionsComplex @summary.attributes
        # Complex Mode
        when 3
          @track Level.EVENTS.subLevel, mode:'complex'
          opts = @_parseOptions true
          @popper = new ClockPopper opts
          @$el.html @popper.render().el
        # Results
        else
          @summary.calculate()
#          console.log summary:@summary
          #@$el.html _tmplScore @summary.attributes
          @track Level.EVENTS.summary, @summary.attributes
          #@track Level.EVENTS.end
          @endLevel()



    # ------------------------------------------------------------- Event Handlers


    # ------------------------------------------------------------- User Activity Tracking

    # ------------------------------------------------------------- Consumable API
    next: -> @_showScreen ++@curScreen
    close: ->
      $('body').removeClass _gameBackgroundClass


  Snoozer