define [
  'underscore'
  'backbone'
  './mediator'
],
(
  _
  Backbone
  Mediator
) ->

  _factory = ->
    new Mediator
      app: _.extend {}, Backbone.Events

  describe 'core/mediator', ->
    it 'exists', ->
      expect(Mediator).toBeDefined()
    it 'must be instantiated with an app option', ->
      expect( -> new Mediator ).toThrow()
      expect(_factory()).toBeInstanceOf(Mediator)



