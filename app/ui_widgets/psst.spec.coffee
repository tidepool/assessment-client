define [
  'underscore'
  'Backbone'
  './psst'
],
(
  _
  Backbone
  psst
) ->

  _myClassName = '.psst'

  beforeEach ->
    jasmine.getFixtures().set sandbox() # Set up an empty #sandbox div that gets cleaned up after every test


  describe 'ui_widgets/psst', ->
    it 'exists', ->
      expect(psst).toBeDefined()
    it 'requires .msg and .sel options', ->
      expect(-> psst()).toThrow()
    it 'adds expected content to the DOM', ->
      psst
        msg: 'Hi There, Mr. Rogers'
        sel: '#sandbox'
      expect($('#sandbox')).toContain _myClassName
      psst.hide()
      expect($('#sandbox')).not.toContain _myClassName










