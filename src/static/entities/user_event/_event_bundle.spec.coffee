define [
  'backbone'
  './_event_bundle'
],
(
  Backbone
  EventBundle
) ->

  _validData =
    game_id: 999
    event_type: 'image_rank'
    stage: 42
  _missingEventType =
    game_id: _validData.game_id
    stage: _validData.stage
  _nonStringEventType =
    game_id: _validData.game_id
    event_type: 999
    stage: _validData.stage
  _missingStage =
    game_id: _validData.game_id
    event_type: _validData.event_type
  _nonIntStage =
    game_id: _validData.game_id
    event_type: _validData.event_type
    stage: 'powderpuff!'
  _missingGameId =
    event_type: _validData.event_type
    stage: _validData.stage
  _invalidEvent =
    favorite_singer: 'Lone Bellow'
  _validEvent =
    event: 'black female president elected'
  _expectedEvents =
    start:             'level_started'
    end:               'level_completed'


  describe 'entities/user_event/_event_bundle', ->
    ebFarnum = {}
    beforeEach -> ebFarnum = new EventBundle _validData
    it 'should be a model', ->
      expect(ebFarnum).toBeInstanceOf Backbone.Model

    describe 'static properties', ->
      it 'exposes an `EVENTS` enum on the class', ->
        expect(EventBundle.EVENTS).toBeDefined()
        expect(EventBundle.EVENTS.start).toEqual _expectedEvents.start
        expect(EventBundle.EVENTS.end).toEqual _expectedEvents.end

    describe 'default properties', ->
      it 'creates an empty backbone collection called `events`', ->
        events = ebFarnum.attributes.events
        expect(events).toBeInstanceOf Backbone.Collection
        expect(events.length).toEqual 0
      it 'the model has a timezone_offset', ->
        expect(ebFarnum.attributes.timezone_offset).toBeDefined()
        expect( -1000 < ebFarnum.attributes.timezone_offset < 1000).toBeTruthy() # Any timezone offset is +- 1000 http://stackoverflow.com/questions/2853474/can-i-get-the-browser-time-zone-in-asp-net-or-do-i-have-to-rely-on-js-operations

    describe 'instantiation requirements', ->
      it 'unless `event_type`, pitches a fit', ->
        expect( -> new EventBundle _missingEventType ).toThrow()
        expect( -> new EventBundle _nonStringEventType ).toThrow()
      it 'gets angry unless sent an integer `stage`', ->
        expect( -> new EventBundle _missingStage ).toThrow()
        expect( -> new EventBundle _nonIntStage ).toThrow()

    describe 'validation requirements', ->
      it 'needs at least one event before it will save', ->
        expect(ebFarnum.save()).toEqual false
        ebFarnum.attributes.events.add _validEvent
        error = ebFarnum.validate ebFarnum.attributes
        expect(error).toEqual null

    describe '`record` method', ->
      it 'has a record method that adds events', ->
        expect(ebFarnum.record).toBeDefined()
        expect(ebFarnum.attributes.events.length).toEqual 0
        ebFarnum.record _validEvent
        expect(ebFarnum.attributes.events.length).toEqual 1
        ebFarnum.record _validEvent
        ebFarnum.record _validEvent
        expect(ebFarnum.attributes.events.length).toEqual 3
      it 'validates by default, so crummy events aren\'t added', ->
        ebFarnum.record _validEvent
        expect(ebFarnum.attributes.events.length).toEqual 1
        ebFarnum.record _invalidEvent
        expect(ebFarnum.attributes.events.length).toEqual 1
        ebFarnum.record _validEvent
        expect(ebFarnum.attributes.events.length).toEqual 2

    describe 'flattens itself for the server', ->

      it 'turns events into a flat array after `toJSON`', ->
        ebFarnum.record _validEvent
        ebFarnum.record _validEvent
        eventsForServer = ebFarnum.toJSON()
        expect(_.isArray eventsForServer.events).toBeTruthy()
        expect(eventsForServer.events.length).toEqual 2








