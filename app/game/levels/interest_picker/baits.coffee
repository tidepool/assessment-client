define [
  'underscore'
  'backbone'
  'classes/model'
], (
  _
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
      dimension: null
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
    getPicked: ->
      picked = @filter (item) -> item.get('isPicked')
      #pickedJSON = []
      #for item in picked
      _.map picked, (item) -> item.toJSON()

  Export.TYPES = _TYPES
  Export

