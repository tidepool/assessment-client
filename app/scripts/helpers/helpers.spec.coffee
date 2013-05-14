define [
  './helpers'
],
(
  Helpers
) ->
  describe 'Helpers', ->
    it 'has a .getQueryParam method', ->
      expect(Helpers.getQueryParam).toBeDefined()

