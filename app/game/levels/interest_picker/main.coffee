define [
  'underscore'
  'backbone'
  'Handlebars'
  'game/levels/_base'
  'text!./interest_picker.hbs'
  './baits'
  './bait_definitions'
  './bait_view'
], (
  _
  Backbone
  Handlebars
  Level
  tmpl
  BaitCollection
  definitions
  BaitView
) ->



  _menuSel = '.menu .content'
  _symbolPicks = 7
  _wordPicks = 3


  Export = Level.extend
    className: 'interestPicker'
#    events:
#      'click .menu .bait': 'onMenuBaitClick'
#      'click .bentoBox .bait': 'onBentoBaitClick'

    # ------------------------------------------------------------- Backbone Methods
    render: ->
      @collection = new BaitCollection _.shuffle definitions
      @listenTo @collection, 'change', @onChange
#      console.log
#        def: definitions
#        collection: @collection
      @$el.html tmpl
      @collection.each (model) =>
        view = new BaitView model:model
        @$(_menuSel).append view.render().el
      @


    _hasPickedEnough: ->
      words = @collection.filter (item) ->
        item.get('isPicked') and (item.get('type') is item.TYPES.word)
      symbols = @collection.filter (item) ->
        item.get('isPicked') and (item.get('type') is item.TYPES.symbol)
#      console.log
#        words: words.length
#        symbols: symbols.length
      true if words.length >= _wordPicks and symbols.length >= _symbolPicks



    # ------------------------------------------------------------- Event Handlers
    onChange: ->
      if @_hasPickedEnough()
        @finalEventData = collection: @collection.toJSON()
        @readyToProceed()
      else
        @notReadyToProceed()


  Export



