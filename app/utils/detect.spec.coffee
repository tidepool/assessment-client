define [
  'underscore'
  './detect'
],
(
  _
  detect
) ->
  describe 'detect', ->

    describe 'isTouch', ->
      it 'has an .isTouch method', ->
        expect(detect.isTouch).toBeDefined()

    describe 'isUIwebView', ->
      it 'exists', ->
        expect(detect.isUIwebView).toBeDefined()

    describe 'isPhone', ->
      it 'exists', -> expect(detect.isPhone).toBeDefined()

    describe 'isPhoneOrTablet', ->
      it 'exists', -> expect(detect.isPhoneOrTablet).toBeDefined()

