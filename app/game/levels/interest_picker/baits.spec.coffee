define [
  'underscore'
  'backbone'
  './baits'
],
(
  _
  Backbone
  BaitCollection
) ->


  _pickedWords = [
    { value: 'Apple-Tree', isPicked: true }
    { value: 'Mango-Tree', isPicked: true }
  ]
  _pickedSymbols = [
    { value: 'gfx-mango', isPicked: true, type: BaitCollection.TYPES.symbol }
    { value: 'gfx-plums', isPicked: true, type: BaitCollection.TYPES.symbol }
    { value: 'gfx-prune', isPicked: true, type: BaitCollection.TYPES.symbol }
  ]
  _unpickedJunk = [
    { value: 'Pear-Trees' }
    { value: 'Grape-Bush' }
    { value: 'gfx-pears', type: BaitCollection.TYPES.symbol }
  ]
  _testData = _.union _pickedWords, _pickedSymbols, _unpickedJunk



  describe 'game/levels/interest_picker/baits', ->
    bait = null

    beforeEach ->
      bait = new BaitCollection _testData

    it 'exists', ->
      expect(BaitCollection).toBeDefined()
      expect(BaitCollection).toBeInstanceOf Backbone.Collection
      expect(bait.model).toBeInstanceOf Backbone.Model

    it 'stores an enum of types', ->
      expect(BaitCollection.TYPES).toBeDefined()
      expect(BaitCollection.TYPES.word).toBeDefined()
      expect(BaitCollection.TYPES.symbol).toBeDefined()

    describe 'test data', ->
      it 'Has the right length', ->
        all = _pickedWords.length + _pickedSymbols.length + _unpickedJunk.length
        expect(_testData.length).toEqual all

    describe 'instantiation', ->
      it 'Starts with the right number of total items', ->
        expect(bait.length).toEqual _testData.length

    describe 'getPicked', ->
      it 'Returns the right number of items', ->
        expect(bait.getPicked().length).toEqual _testData.length - _unpickedJunk.length
        expect(bait.getPickedWords()[0]).toBeInstanceOf bait.model

    describe 'getPickedWords', ->
      it 'Returns the right items', ->
        expect(bait.getPickedWords().length).toEqual _pickedWords.length
        expect(bait.getPickedWords()[0]).toBeInstanceOf bait.model

    describe 'getPickedSymbols', ->
      it 'Returns the right items', ->
        expect(bait.getPickedSymbols().length).toEqual _pickedSymbols.length
        expect(bait.getPickedWords()[0]).toBeInstanceOf bait.model

    describe 'countPickedWords', ->
      it 'Returns the right count', ->
        expect(bait.countPickedWords()).toEqual _pickedWords.length

    describe 'countPickedSymbols', ->
      it 'Returns the right count', ->
        expect(bait.countPickedSymbols()).toEqual _pickedSymbols.length
