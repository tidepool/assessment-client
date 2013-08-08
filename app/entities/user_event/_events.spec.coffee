define [
  'backbone'
  './_events'
],
(
  Backbone
  Events
) ->

  _testData = [
    { 'silly':'pants' }
    { 'silly':'bannana' }
  ]
  _goodEvent = {
    event: 'event one'
  }
  _goodEvents = [
    _goodEvent
    _goodEvent
  ]
  _errMsg = 'Requires the `event` property'



  describe 'entities/user_event/_events', ->
    events = {}

    beforeEach ->
      events = new Events _testData

    it 'should be a collection', ->
      expect(events).toBeInstanceOf Backbone.Collection
      expect(events.length).toEqual _testData.length



    describe 'default properties', ->

      it 'the models have a timestamp', ->
        event = events.pop()
        expect(event.attributes.time).toBeDefined()
        diff = (new Date()).getTime() - event.attributes.time
        expect(0 <= diff < 500).toBeTruthy() # Any reasonable timestamp should be less than .5 seconds ago in this situation



    describe 'required properties', ->

      it 'yells if you try to save invalid data', ->
        event = events.pop()
        expect(event.save()).toEqual false # A backbone model that fails validation returns 'false' from save: http://backbonejs.org/#Model-save

      it 'good events pass validation', ->
        validatedEvents = new Events
        validatedEvents.add _testData, {validate:true}
        expect(validatedEvents.length).toEqual 0
        validatedEvents.add _goodEvents, {validate:true}
        expect(validatedEvents.length).toEqual 2


