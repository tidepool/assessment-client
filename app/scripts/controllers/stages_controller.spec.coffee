define [
  './stages_controller'
],
(
  StagesController
) ->

  describe 'controllers/stages_controller', ->

    it 'exists', ->
      expect(StagesController).toBeDefined()

    it 'enforces instantiation in a certain way', ->
      expect( -> new StagesController() ).toThrow()
      stages = new StagesController
        assessment: new Backbone.Model()
      expect(stages).toBeInstanceOf StagesController

