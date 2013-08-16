
define [
  'backbone'
  'Handlebars'
  'text!./person_vessel_view.hbs'
  'ui_widgets/proceed'
],
(
  Backbone
  Handlebars
  tmpl
  proceed
) ->


  _currentClass = 'current'
  _doneClass = 'finished'
  _initialClass = 'untouched'
  _instructionsSel = '.instructions'
  _fillSel = '.fill'
  _personMaskSel = '.mask'
  _outputSel = "#{_fillSel} output"
  _tmpl = Handlebars.compile tmpl

  View = Backbone.View.extend

    # ----------------------------------------------------- Backbone Extensions
    className: 'personVessel'
    tagName: 'li'
    events:
      touchstart: 'onDragStart'
      touchmove:  'onDragMove'
      touchend:   'onDragStop'
      mousedown:  'onMouseDown'
      mousemove:  'onMouseMove'
      mouseup:    'onMouseUp'
#      'mouseout':   'onMouseOut'

    initialize: ->
      @listenTo @model, 'change:interacted', @onChangeInteracted

    render: ->
      @$el.html _tmpl @model.attributes
      @


    # ----------------------------------------------------- Private Methods
    # Match the height of the fill to the current position of the pointer
    _match: (event) ->
      @windowHeight = $(window).height() # force recalculation of these because they can change on window resize
      @personHeight = @$el.height()
      @_follow event
    # Continue following the height to pointer movements
    _follow: (event) ->
      @windowHeight = @windowHeight || $(window).height() # Don't calculate window height every drag increment :)
      @personHeight = @personHeight || @$el.height()
      @$fill =        @$fill || @$(_fillSel)
      @$output =      @$output || @$(_outputSel)
      # Handle positions from both mouse and touch events
      if event.pageY
        y = event.pageY
      else
        touch = event.originalEvent.touches[0] || event.originalEvent.changedTouches[0]
        y = touch.pageY
      height = @windowHeight - y
      percentage = Math.round height / @personHeight * 100
      percentage = @_boundValue percentage
#      console.log
#        event: event
#        windowH: @windowHeight
#        distFromBot: height
#        imgHeight: @imgHeight
#        percentage: percentage
      @$fill.css height: height
      @$output.text "#{percentage}%"
      percentage

    _setValues: (event) ->
      @model.set percentage: @_follow(event)
      @

    _setHeightFromPercentage: (percentage) ->
      @personHeight = @personHeight || @$el.height()
      @$fill =        @$fill || @$(_fillSel)
      @$output =      @$output || @$(_outputSel)
      @$fill.css height: @personHeight * percentage/100
      @$output.text "#{percentage}%"
      proceed.show()

    # Limit by 0 and 100
    _boundValue: (val) ->
      val = if val > 100 then 100 else val
      val = if val <= 0 then 0 else val
      val


    # ----------------------------------------------------- Mouse Events
    onMouseDown: (event) ->
      event.originalEvent?.preventDefault() # http://stackoverflow.com/questions/2745028/chrome-sets-cursor-to-text-while-dragging-why
      @isDragging = true
      @onDragStart event

    onMouseMove: (event) ->
      @onDragMove event if @isDragging

    onMouseUp: (event) ->
      @isDragging = false
      @onDragStop event


    # ----------------------------------------------------- Touch Events
    onDragStart: (event) ->
      @model.set interacted:true
      @_match event

    onDragMove: (event) ->
      event.preventDefault()
      @_follow event

    onDragStop: (event) ->
      @_setValues event
      proceed.show()


    # ----------------------------------------------------- Model Events
    onChangeInteracted: (model, changedAttribute) ->
      @$el.removeClass _initialClass


    # ----------------------------------------------------- Consumable API
    yourTurn: ->
      @$el.addClass "#{_currentClass} #{_initialClass}"
      @$(_fillSel).attr tabindex:1
      @

    done: ->
      @$el.addClass _doneClass
      @$(_fillSel).attr tabindex:-1
      @

    # Bump the percentage up or down to the next step
    bumpUp: ->
      percent = @model.get 'percentage'
      if percent?
        newVal = Math.round(percent / 10) + 1
      else
        newVal = 1
      newVal *= 10
      newVal = @_boundValue newVal
      @model.set percentage:newVal
      @_setHeightFromPercentage newVal
      @

    bumpDown: ->
      percent = @model.get 'percentage'
      if percent?
        newVal = Math.round(percent / 10) - 1
      else
        newVal = 0
      newVal *= 10
      newVal = @_boundValue newVal
      @model.set percentage:newVal
      @_setHeightFromPercentage newVal
      @

    close: ->
      # Clean up instance variables
      delete @$fill
      delete @personHeight
      delete @windowHeight
      delete @isDragging
      delete @$output

  View




