define [
  './config'
],
(
  config
) ->
  describe 'core/config', ->
    it 'exists', ->
      expect(config).toBeDefined()
    it 'has expected properties', ->
      expect(config.appName).toBeDefined()
