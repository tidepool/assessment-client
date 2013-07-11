define [
  'underscore'
  'backbone'
  './perch'
],
(
  _
  Backbone
  perch
) ->

  _myClassName = 'perch'
  _mySel = ".#{_myClassName}"
  _testMsg = 'Raindrops keep falling on my head.'
  _testMsg2 = 'In Hertford, Hereford, and Hampshire, hurricanes hardly ever happen.'
  _testObj =
    title: 'Test Title'
    content: _testMsg
  _animationTime = 300

  describe 'composite_views/perch', ->
    it 'exists and is already instantiated', -> expect(perch).toBeDefined()
    it 'is is instantiated by default', -> expect(typeof perch).toEqual("object")

    describe 'it has a show method', ->

      it '.show is defined', ->
        expect(perch.show).toBeDefined()

#      it '.show can display a string', ->
#        perch.show _testMsg
#        waits _animationTime
#        runs ->
#          expect( $('body') ).toContain _mySel
#          expect( $('body') ).toContainText _testMsg
#          expect( $(_mySel) ).toBeVisible()
#          perch.hide()
#        waits _animationTime
#
#      it 'creates a lightbox with a button by default', ->
#        perch.show _testMsg
#        waits _animationTime
#        runs ->
#          expect( $(_mySel) ).toContain '.btn'
#          expect( $("#{_mySel} .btn") ).toHaveLength 1 # there can only be one
#          perch.hide()
#        waits _animationTime

    describe 'in cleans up after itself nicely', ->

      it 'blanks out the title if a previous perch user had a title', ->
        perch.show _testObj
        waits _animationTime
        runs ->
          expect( $(_mySel) ).toContainText _testObj.title
          perch.hide()
        waits _animationTime
        runs ->
          perch.show _testMsg2
        waits _animationTime
        runs ->
          expect( $(_mySel) ).not.toContainText _testObj.title
          perch.hide()
        waits _animationTime

