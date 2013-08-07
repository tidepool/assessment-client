define [
  'underscore'
  'backbone'
  'Handlebars'
  'game/levels/_base'
  'utils/numbers'
  'text!./interest_picker.hbs'
  './baits'
  './bait_definitions'
  './bait_view'
], (
  _
  Backbone
  Handlebars
  Level
  numbers
  tmpl
  BaitCollection
  definitions
  BaitView
) ->



  _rowSel = '.menu .row'
  _blocked = 'blocked' # Don't add the bait to this row
  _symbolPicks = 7
  _wordPicks = 3
  _tempo = 500 # How often to add a new symbol
  _travelTime = 5000 # Time for a symbol to cross the screen
  #TODO: _timeLimit = 20 * 1000
  _wordCountSel = '#WordCount'
  _symbolCountSel = '#SymbolCount'
  _wordCountTmpl =   Handlebars.compile   "Words <span class='muted'>{{count}}/#{_wordPicks}</span>"
  _symbolCountTmpl = Handlebars.compile "Symbols <span class='muted'>{{count}}/#{_symbolPicks}</span>"
  _EVENTS =
    start:             'test_started'


  Export = Level.extend
    className: 'interestPicker'
    CollectionClass: BaitCollection

    start: ->
      @track _EVENTS.start
      @collection.reset @collection.shuffle(), { silent:true }
      @collection.each (model) ->
        view = new BaitView model:model
        model.view = view
      @listenTo @collection, 'change', @onChange
      _.bindAll @, '_step'
      @_i = 0
      @_interval = setInterval @_step, _tempo
      @


    # ------------------------------------------------------------- Backbone Methods
    render: ->
      @$el.html tmpl
      @_updateCounts()
      @


    _hasPickedEnough: ->
      words = @collection.filter (item) ->
        item.get('isPicked') and (item.get('type') is item.TYPES.word)
      symbols = @collection.filter (item) ->
        item.get('isPicked') and (item.get('type') is item.TYPES.symbol)
      true if words.length >= _wordPicks and symbols.length >= _symbolPicks







    # Pull the symbol off the dom
    # Clean up any events
    # Make it available for placement again (put it in a queue of things to show)


    # Every _tempo add another symbol
    _step: ->
      model = @collection.at(@_i)
      if model and not model.attributes.isPicked
        # Pick a vertical place to add the bait at random
        @_pickRow().append model.view.render().el
      else
        @_i++
        @_step()
      # increment a counter limited by 0 and the collection.length
      @_i++
      @_i = 0 if @_i >= @collection.length

      # Cleanup symbols as they reach the end of the buffet

    # Pick a random row to put the bait in, but not if the row is blocked with something.
    # Blocked is determined by last used for now
    _pickRow: ->
      el = numbers.pickOneAnyOne $("#{_rowSel}:not('.#{_blocked}')")
      $(_rowSel).removeClass _blocked
      $(el).addClass _blocked

    _updateCounts: ->
      console.log 'update'
      $(_symbolCountSel).html _symbolCountTmpl count:@collection.countPickedSymbols()
      $(_wordCountSel).html     _wordCountTmpl count:@collection.countPickedWords()


    # ------------------------------------------------------------- Event Handlers
    onChange: (model) ->
      @_updateCounts()
      switch model.attributes.type
        when model.TYPES.word
          if @collection.countPickedWords() > _wordPicks
            model.view.unpick().sayNo()
        when model.TYPES.symbol
          if @collection.countPickedSymbols() > _symbolPicks
            model.view.unpick().sayNo()
      if @_hasPickedEnough()
        @finalEventData = collection: @collection.toJSON()
        @readyToProceed()
      else
        @notReadyToProceed()


    # ------------------------------------------------------------- Event Handlers
    close: ->
      clearInterval @_interval
      @remove()
      # Clean up all intervals and timeouts
      # Clean up event listeners
      # Remove stuff from DOM



  Export



