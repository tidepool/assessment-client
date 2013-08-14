define [
  'backbone'
  'classes/model'
], (
  Backbone
  Model
) ->

  _TYPES =
    word: 'word'
    symbol: 'symbol'

  Bait = Model.extend
    TYPES: _TYPES
    defaults:
      type: _TYPES.symbol
      value: 'Default'
      desc: null
      isPicked: null
      factors:
        realistic:     null
        investigative: null
        artistic:      null
        social:        null
        enterprising:  null
        conventional:  null

  Export = Backbone.Collection.extend
    model: Bait
    countPickedWords: ->
      words = @filter (item) ->
        item.get('isPicked') and (item.get('type') is item.TYPES.word)
      words.length
    countPickedSymbols: ->
      symbols = @filter (item) ->
        item.get('isPicked') and (item.get('type') is item.TYPES.symbol)
      symbols.length

  Export.TYPES = _TYPES
  Export

