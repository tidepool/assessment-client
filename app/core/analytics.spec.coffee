define [
  './analytics'
],
(
  Analytics
) ->
  describe 'core/analytics', ->
    it 'exists', ->
      expect(Analytics).toBeDefined()
    it 'has an enforced API', ->
      expect( -> new Analtyics ).toThrow()
      anna = new Analytics
        googleAnalyticsKey: 1234
      expect(anna).toBeInstanceOf(Analytics)

