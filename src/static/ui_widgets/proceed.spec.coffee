define [
  'underscore'
  'backbone'
  './proceed'
],
(
  _
  Backbone
  proceed
) ->

  _myClassName = '.proceed'

  beforeEach ->
    jasmine.getFixtures().set sandbox() # Set up an empty #sandbox div that gets cleaned up after every test


  describe 'ui_widgets/proceed', ->
    it 'exists and is a Backbone.View instance', ->
      expect(proceed).toBeDefined()
      expect(proceed).toBeInstanceOf(Backbone.View)

    describe '.render and .show', ->
      it 'doesn\'t add content to the dom if .show is not called', ->
        expect($(_myClassName)).toHaveLength 0
      it 'adds itself to the dom if .show is called', ->
        proceed.show()
        expect($(_myClassName)).toHaveLength 1
        proceed.hide()
        expect($(_myClassName)).toHaveLength 0
      it 'doesn\'t add itself multiple times if show is called a bunch', ->
        proceed.show()
        proceed.show()
        proceed.show()
        expect($(_myClassName)).toHaveLength 1
        proceed.hide()
        expect($(_myClassName)).toHaveLength 0
      it 'cleans its mess out of the dom if .hide is called', ->
        proceed.render()
        expect($(_myClassName)).toHaveLength 1
        proceed.hide()
        expect($(_myClassName)).toHaveLength 0
      it 'even when triggered as callbacks on other objects, .show and .hide work (`this` binding is correctly maintained)', ->
        fred = {}
        fred.wasClicked = proceed.show
        fred.wasClicked()
        expect($(_myClassName)).toHaveLength 1
        proceed.hide()
        expect($(_myClassName)).toHaveLength 0

    describe 'it throws a click event', ->
      it 'throws `click` on the view when a child DOM element is clicked', ->
        proceed.show()
        clickCount = 0
        proceed.on 'click', -> clickCount++
        $(_myClassName).find('i:first-child').trigger 'click'
        expect(clickCount).toEqual 1
        proceed.hide()





