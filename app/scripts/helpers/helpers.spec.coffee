define [
  './helpers'
],
(
  Helpers
) ->
  describe 'Helpers', ->
    it 'has a .getQueryParam method', ->
      expect(Helpers.getQueryParam).toBeDefined()
#    it 'is awesome', ->
#      expect(80085).toBe(1)

