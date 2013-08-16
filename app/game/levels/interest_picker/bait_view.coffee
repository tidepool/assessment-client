define [
  'jquery'
  'underscore'
  'backbone'
  'Handlebars'
  'text!./bait_symbol.hbs'
], (
  $
  _
  Backbone
  Handlebars
  tmplSymbol
) ->

  _tmplSymbol = Handlebars.compile tmplSymbol
  _bentoSel = '.bentoBox'
  _expandedClass = 'expanded'
  _animTime = 200
  _bentoBoxes =
    word: '.bentoBox .words.content'
    symbol: '.bentoBox .symbols.content'
  _menuSel = '.menu .content'
  _slidingClass = 'sliding'
  _pickAnimClass = 'picked'
  _naughtyClass = 'naughty'

  Export = Backbone.View.extend
    className: 'bait'
    events:
      'mousedown': 'onClick'
      'touchstart': 'onClick'

    # ------------------------------------------------------------- Backbone Methods
    initialize: ->
      _.bindAll @, '_picked'

    render: ->
      @_reset()
      if @model.attributes.type is @model.TYPES.symbol
        @$el.html _tmplSymbol @model.attributes
        @$el.addClass @model.TYPES.symbol
      else
        @$el.text @model.attributes.value
        @$el.addClass @model.TYPES.word
      # Animation Trigger Class
      setTimeout (=> @$el.addClass _slidingClass), 10
      @

    onClick: (e) ->
      e.preventDefault()
      # Move from Picked -> Unpicked
      if @model.attributes.isPicked
        @unpick().remove()
      # Save this one!
      else
        @_pick()

    _reset: ->
      @delegateEvents()
      @$el.removeClass _slidingClass
      @$el.removeClass _pickAnimClass
      @$el.removeClass _naughtyClass

    _pick: ->
      @timeout = setTimeout @_picked, _animTime
      @$el.addClass _pickAnimClass
      @model.set
        isPicked: true
        record_time: (new Date()).getTime()
        @

    _picked: ->
      @_reset()
      @$el.appendTo _bentoBoxes[@model.attributes.type]


    # ------------------------------------------------------------- Consumable API
    unpick: ->
      clearTimeout @timeout
      @model.set
        isPicked: false
        record_time: (new Date()).getTime()
      @_reset()
      @

    sayNo: ->
      @$el.addClass _naughtyClass
      $(_bentoSel).addClass _expandedClass
      @timeout = setTimeout (=> @$el.addClass(_slidingClass).removeClass _naughtyClass), _animTime * 2
      @

    close: ->
      clearTimeout @timeout
      @


  Export