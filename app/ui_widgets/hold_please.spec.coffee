define [
  'underscore'
  'backbone'
  './hold_please'
],
(
  _
  Backbone
  holdPlease
) ->

  _parentClassName = '.onHold'
  _myClassName = '.holdPlease'
  _factory = ->
    $s = $('#sandbox')
    $s.html "
      <p>
        <div class='btn btn-success btn-large' data-printClasses></div>
      </p>
      <p>
        <button class='btn btn-primary btn-large' data-printClasses></button>
      </p>
    "
    $s

  beforeEach ->
    jasmine.getFixtures().set sandbox() # Set up an empty #sandbox div that gets cleaned up after every test


  describe 'ui_widgets/hold_please', ->
    it 'exists and has .show and .hide methods', ->
      expect(holdPlease).toBeDefined()
      expect(holdPlease.show).toBeDefined()
      expect(holdPlease.hide).toBeDefined()
    it 'adds itself to an element when .show is called with a selector', ->
      $sandbox = _factory()
      holdPlease.show '.btn-success'
      expect($sandbox).toContain _myClassName
    it 'removes itself when .hide is called with a selector', ->
      $sandbox = _factory()
      holdPlease.show '.btn-success'
      expect($sandbox).toContain _myClassName
      holdPlease.hide '.btn-success'
      expect($sandbox).not.toContain _myClassName
    it 'can be applied to multiple elements using two different calls to show', ->
      $sandbox = _factory()
      holdPlease.show '.btn-success'
      holdPlease.show '.btn-primary'
      expect($sandbox.find(_myClassName)).toHaveLength 2
    it 'can be applied to multiple elements using a single bulk selector', ->
      $sandbox = _factory()
      holdPlease.show '.btn'
      expect($sandbox.find(_myClassName)).toHaveLength 2
    it 'cleans up after itself nicely', ->
      $sandbox = _factory()
      holdPlease.show '.btn'
      expect($sandbox).toContain _parentClassName
      expect($sandbox.find(_myClassName)).toHaveLength 2
      holdPlease.hide '.btn'
      expect($sandbox).not.toContain _myClassName
      expect($sandbox).not.toContain _parentClassName
    it 'removes all instances of itself and cleans up if .hide() is called with no parameters', ->
      $sandbox = _factory()
      holdPlease.show '.btn'
      expect($sandbox.find(_myClassName)).toHaveLength 2
      holdPlease.hide()
      expect($sandbox).not.toContain _myClassName
      expect($sandbox).not.toContain _parentClassName










