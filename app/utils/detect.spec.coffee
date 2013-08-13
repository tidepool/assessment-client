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
      it 'returns false (since you\'re running this on a desktop device)', ->
        expect(detect.isTouch()).toBeFalsy()

    describe 'isUIwebView', ->
      it 'exists', ->
        expect(detect.isUIwebView).toBeDefined()
      it 'returns false (since you\'re running this on a desktop device)', ->
        expect(detect.isUIwebView()).toBeFalsy()
