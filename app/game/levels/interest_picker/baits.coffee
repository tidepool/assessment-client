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

  _toJSONEach = (array) ->
    outbound = _.map array, (item) -> item.toJSON()
    outbound

  Bait = Model.extend
    TYPES: _TYPES
    defaults:
      type: _TYPES.word
      value: 'Default'
      dimension: null
      isPicked: null
    toJSON: (options) ->
      attrs = _.clone @attributes
      delete attrs.isPicked
      attrs

  Export = Backbone.Collection.extend
    model: Bait
    getPicked: ->          _toJSONEach @filter (item) -> item.get('isPicked')
    getPickedWords: ->     _toJSONEach @filter (item) -> item.get('isPicked') and (item.get('type') is item.TYPES.word)
    getPickedSymbols: ->   _toJSONEach @filter (item) -> item.get('isPicked') and (item.get('type') is item.TYPES.symbol)
    countPickedWords: ->   @getPickedWords().length
    countPickedSymbols: -> @getPickedSymbols().length

  Export.TYPES = _TYPES
  Export

