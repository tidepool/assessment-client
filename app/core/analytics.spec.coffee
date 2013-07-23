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

    #it 'has a .track method', ->
    #it 'has a .trackPage method', ->
    #it 'has a .trackBizEvent method', ->

