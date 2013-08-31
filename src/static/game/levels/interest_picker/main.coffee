define [
  'underscore'
  'backbone'
  'Handlebars'
  'game/levels/_base'
  'utils/numbers'
  'text!./interest_picker.hbs'
  'text!./count.hbs'
  './baits'
  './bait_view'
], (
  _
  Backbone
  Handlebars
  Level
  numbers
  tmpl
  countTmpl
  BaitCollection
  BaitView
) ->


  _minPicks = 7
  _tempo = 800 # How often to add a new symbol
  _drawerSize = 53 # how large is the drawer that shows up at the bottom on small screens?
  _margins = 50
  _rowCount = 4 # How many rows of items to show
#  _travelTime = 12 * 1000 # Time for a symbol to cross the screen
  _menuSel =         '.menu'
  _rowSel =          '.menu .row'
  _countSel =        '#CountSeen'
  _doneClass =       'done'
  _blockedClass =    'blocked' # Don't add the bait to this row
  _wordContentSel =  '.content.words'
  _symbolContentSel ='.content.symbols'
  _wordCountSel =    '#WordCount'
  _symbolCountSel =  '#SymbolCount'
  _countdownSel =    '.countdown'
  _bentoSel =        '.bentoBox'
  _shimmerClass =    'shimmer'
  _expandedClass =   'expanded'
  _countTmpl =       Handlebars.compile countTmpl
  _tmpl =            Handlebars.compile tmpl
  _doneIcon = '<i class="icon-ok-sign"></i>'
  _doneMarkup = "<output class='good'>#{_doneIcon} Done</output>"


  Export = Level.extend
    className: 'interestPicker'
    CollectionClass: BaitCollection
    events:
      'click .bentoBox .title': 'onClickTitle'
      'click .bentoBox .groovy': 'onClickTitle'
      'click .menu': 'onClickMenu'

    start: ->
      @track Level.EVENTS.start
      @collection.reset @collection.shuffle(), { silent:true }
      @collection.each (model) ->
        view = new BaitView model:model
        model.view = view
      @listenTo @collection, 'change', @onChange
      @heightAdjustment = _drawerSize + _margins
      @summaryData = {}
      @once 'domInsert', @fillHeight
      _.bindAll @, '_step', '_startSteppin', '_stopSteppin'
      @_i = 0
      # Don't keep throwing symbols when the window isn't focused, otherwise they'll stack up
      $(window).on 'blur',  @_stopSteppin
      $(window).on 'focus', @_startSteppin
      @_updateCounts()
      @_startSteppin()
      @


    # ------------------------------------------------------------- Backbone Methods
    render: ->
      rows = (i for i in [1.._rowCount]) # The numbers themselves aren't really used, Handlebars just needs something to iterate over
      @$el.html _tmpl
        rows: rows
        rowHeight: "#{Math.floor(1 / rows.length * 100)}%" # convert to a percentage
      @


    # ------------------------------------------------------------- Private Methods
    _startSteppin: ->
      clearInterval @_interval
      @_interval = setInterval @_step, _tempo

    _stopSteppin: -> clearInterval @_interval

    _hasPickedEnough: ->
      true if @collection.countPickedWords() + @collection.countPickedSymbols() >= _minPicks

    # Every _tempo add another symbol
    _step: ->
      console.log 'step'
      model = @collection.at(@_i)
      if model and not model.attributes.isPicked
        # Pick a vertical place to add the bait at random
        @_pickRow().append model.view.render().el
      # Counter bound by 0 and the collection.length
      @_i++

      if @_i >= @collection.length
        @_i = 0
        @_seenAll = true

      if @_seenAll
        $(_countSel).html(_doneIcon)
        setTimeout (-> $(_countSel).addClass _doneClass), 500
      else
        $(_countSel).text("#{@_i}/#{@collection.length}")

      @_proceedIfDone()

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

    _updateWordCount: (count) ->   $(_wordCountSel).html   _countTmpl count:count
    _updateSymbolCount: (count) -> $(_symbolCountSel).html _countTmpl count:count

    # Given a selector, add a class that makes it shimmer like the moonlight on a breezy pond
    _shimmerSel: (sel) ->
      $el = $(sel)
      $el.removeClass _shimmerClass
      setTimeout (-> $el.addClass _shimmerClass), 1 # This delay lets the dom notice and animate the added class

    # A 'cheater' method for allowing us to speed past this game. Picks enough items to allow you to proceed
    _pickAll: ->
      @summaryData.cheater_pick = true
      @_seenAll = true
      @collection.each (model) -> model.view._pick() # Accessing a private method but it's for a dev-only hack so I'm already misbehaving.

    _proceedIfDone: ->
      if @_hasPickedEnough() and @_seenAll
        @summaryData = _.extend @summaryData,
          symbol_list: @collection.getPickedSymbols()
          word_list:   @collection.getPickedWords()
        @readyToProceed()
      else
        @notReadyToProceed()


    # ------------------------------------------------------------- Event Handlers
    onChange: (model) ->
      @_updateCounts()
      @_onBaitChange model
      @_proceedIfDone()

    # Given a model that has just changed, log a user event for it
    _onBaitChange: (model) ->
      switch model.attributes.isPicked
        when true
          @track Level.EVENTS.selected, model.toJSON()
        when false
          @track Level.EVENTS.deselected, model.toJSON()

    onClickTitle: (e) ->
      $(_bentoSel).toggleClass _expandedClass

    onClickMenu: (e) ->
      # Hold [CMD/CTRL] + [SHIFT] + [ALT] to skip the level
      @_pickAll() if (e.metaKey or e.ctrlKey) and e.shiftKey and e.altKey


    # ------------------------------------------------------------- Event Handlers
    close: ->
      # Clean up all intervals and timeouts
      clearInterval @_interval
      $(window).off 'blur',  @_stopSteppin
      $(window).off 'focus', @_startSteppin


  Export


