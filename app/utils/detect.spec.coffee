define [
  'underscore'
  './detect'
],
(
  _
  detect
) ->
  describe 'detect', ->
    it 'has an .isTouch method', ->
      expect(detect.isTouch).toBeDefined()
    it 'returns false (since you\'re running this on a desktop device)', ->
      expect(detect.isTouch()).toBeFalsy()
