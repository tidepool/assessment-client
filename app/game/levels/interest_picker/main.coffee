define [
  'underscore'
  'backbone'
  'Handlebars'
  'game/levels/_base'
  'utils/numbers'
  'text!./interest_picker.hbs'
  './baits'
  './bait_view'
], (
  _
  Backbone
  Handlebars
  Level
  numbers
  tmpl
  BaitCollection
  BaitView
) ->




  _symbolPicks = 7
  _wordPicks = 3
  _tempo = 800 # How often to add a new symbol
  _travelTime = 12 * 1000 # Time for a symbol to cross the screen
  _rowSel = '.menu .row'
  _blockedClass = 'blocked' # Don't add the bait to this row
  _wordContentSel =  '.content.words'
  _symbolContentSel ='.content.symbols'
  _wordCountSel =    '#WordCount'
  _symbolCountSel =  '#SymbolCount'
  _countdownSel =    '.countdown'
  _shimmerClass =    'shimmer'
  _wordCountTmpl =   Handlebars.compile   "Words <span class='muted'>{{count}}/#{_wordPicks}</span>"
  _symbolCountTmpl = Handlebars.compile "Symbols <span class='muted'>{{count}}/#{_symbolPicks}</span>"
  _tmpl =            Handlebars.compile tmpl
  _doneMarkup = '<span class="good"><i class="icon-ok-sign"></i> Done</span>'


  Export = Level.extend
    className: 'interestPicker'
    CollectionClass: BaitCollection

    start: ->
      @track Level.EVENTS.start
      @collection.reset @collection.shuffle(), { silent:true }
      @collection.each (model) ->
        view = new BaitView model:model
        model.view = view
      @listenTo @collection, 'change', @onChange
      _.bindAll @, '_step', '_startSteppin'
      @_i = 0
      # Don't keep throwing symbols when the window isn't focused, otherwise they'll stack up
      $(window).blur => clearInterval @_interval
      $(window).focus @_startSteppin
      @_startSteppin()
      @


    # ------------------------------------------------------------- Backbone Methods
    render: ->
      @$el.html _tmpl
        words: _wordPicks
        symbols: _symbolPicks
      @_updateCounts()
      @


    # ------------------------------------------------------------- Private Methods
    _startSteppin: ->
      clearInterval @_interval
      @_interval = setInterval @_step, _tempo

    _hasPickedEnough: ->
      words = @collection.filter (item) ->
        item.get('isPicked') and (item.get('type') is item.TYPES.word)
      symbols = @collection.filter (item) ->
        item.get('isPicked') and (item.get('type') is item.TYPES.symbol)
      true if words.length >= _wordPicks and symbols.length >= _symbolPicks

    # Every _tempo add another symbol
    _step: ->
      model = @collection.at(@_i)
      if model and not model.attributes.isPicked
        # Pick a vertical place to add the bait at random
        @_pickRow().append model.view.render().el
      # Counter bound by 0 and the collection.length
      @_i++
      @_i = 0 if @_i >= @collection.length

    # Pick a random row to put the bait in, but not if the row is blocked with something.
    # Blocked is determined by last used for now
    _pickRow: ->
      el = numbers.pickOneAnyOne $("#{_rowSel}:not('.#{_blockedClass}')")
      $(_rowSel).removeClass _blockedClass
      $(el).addClass _blockedClass

    _updateCounts: ->
      $(_countdownSel).hide()
      @_updateWordCount   @collection.countPickedWords()   unless @_lastWordCount is @collection.countPickedWords()
      @_updateSymbolCount @collection.countPickedSymbols() unless @_lastSymbCount is @collection.countPickedSymbols()
      @_lastWordCount = @collection.countPickedWords()
      @_lastSymbCount = @collection.countPickedSymbols()

    _updateWordCount: (count) ->
      if count is _wordPicks
        $(_wordCountSel).html _doneMarkup
        @_shimmerSel _wordContentSel
      else
        $(_wordCountSel).html _wordCountTmpl count:count

    _updateSymbolCount: (count) ->
      if count is _symbolPicks
        $(_symbolCountSel).html _doneMarkup
        @_shimmerSel _symbolContentSel
      else
        $(_symbolCountSel).html _symbolCountTmpl count:count

    # Given a selector, add a class that makes it shimmer like the moonlight on a breezy pond
    _shimmerSel: (sel) ->
      $el = $(sel)
      $el.removeClass _shimmerClass
      setTimeout (-> $el.addClass _shimmerClass), 1 # This delay lets the dom notice and animate the added class


    # ------------------------------------------------------------- Event Handlers
    onChange: (model) ->
      @_updateCounts()
      @_onBaitChange model
      switch model.attributes.type
        when model.TYPES.word
          if @collection.countPickedWords() > _wordPicks
            model.view.unpick().sayNo()
        when model.TYPES.symbol
          if @collection.countPickedSymbols() > _symbolPicks
            model.view.unpick().sayNo()
      if @_hasPickedEnough()
        @summaryData = picked: @collection.getPicked()
        @readyToProceed()
      else
        @notReadyToProceed()

    # Given a model that has just changed, log a user event for it
    _onBaitChange: (model) ->
      switch model.attributes.isPicked
        when true
          @track Level.EVENTS.selected, model.toJSON()
        when false
          @track Level.EVENTS.deselected, model.toJSON()
        else
          console.warn 'Twilight zone. Neither picked nor not picked'


    # ------------------------------------------------------------- Event Handlers
    close: ->
      # Clean up all intervals and timeouts
      clearInterval @_interval
      $(window).off() # Lose all the window focus/blur events
      # Remove stuff from DOM
      @remove()


  Export


