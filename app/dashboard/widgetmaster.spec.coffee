define [
  'underscore'
  'backbone'
  './widgetmaster'
],
(
  _
  Backbone
  Widgetmaster
) ->

  _goodKey = 'dashboard/personality/detailed_report'
  _badKey = 'dashboard/fake/widget'

  beforeEach ->
    jasmine.getFixtures().set sandbox() # Set up an empty #sandbox div that gets cleaned up after every test

  describe 'dashboard/widgetmaster', ->
    it 'exists', ->
      expect(Widgetmaster).toBeDefined()

    it 'requires a `widgets` option', ->
      expect( -> new Widgetmaster).toThrow()
      good = new Widgetmaster
        widgets: [ _badKey ]
      expect(good).toBeInstanceOf Backbone.View

    it 'instantiates a dashboard widget instance if you give it a module id it knows', ->
      widgey = new Widgetmaster
        widgets: [ _goodKey ]
      expect(widgey.widgets[_goodKey]).toBeInstanceOf Backbone.View

    it 'fails gracefully if you give it a mix of good and bad widget keys', ->
      widgey = new Widgetmaster
        widgets: [ _badKey, _goodKey ]
      expect(widgey.widgets[_goodKey]).toBeInstanceOf Backbone.View
      expect(widgey.widgets[_badKey]).not.toBeDefined()



