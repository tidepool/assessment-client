define [
  './analytics'
],
(
  Analytics
) ->
  describe 'core/analytics', ->
    it 'exists', ->
      expect(Analytics).toBeDefined()
    it 'must be instantiated a certain way', ->
      expect( -> new Analtyics ).toThrow()
      anna = new Analytics
        googleAnalyticsKey: 1234
      expect(anna).toBeInstanceOf(Analytics)

