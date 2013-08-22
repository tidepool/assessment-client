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
      type: _TYPES.word
      value: 'Default'
      dimension: null
      isPicked: null


  Export = Backbone.Collection.extend
    model: Bait
    getPicked: ->
      picked = @filter (item) -> item.get('isPicked')
      #pickedJSON = []
      #for item in picked
      _.map picked, (item) -> item.toJSON()
    getPickedWords: ->     @filter (item) -> item.get('isPicked') and (item.get('type') is item.TYPES.word)
    getPickedSymbols: ->   @filter (item) -> item.get('isPicked') and (item.get('type') is item.TYPES.symbol)
    countPickedWords: ->   @getPickedWords().length
    countPickedSymbols: -> @getPickedSymbols().length

  Export.TYPES = _TYPES
  Export

