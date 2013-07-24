define [
  'underscore'
  'backbone'
  './model'
],
(
  _
  Backbone
  Model
) ->

  _data =
    name: 'Lars'
    email: 'lars@gmail.com'
    visits: 42
  _successfulResposnse =
    status: {}
    data: _data
  _unwrappedResponse = _data
  _failedResponse = null


  describe 'classes/model', ->
    model = null # get it in scope

    beforeEach ->
      model = new Model _data

    describe 'the basics', ->
      it 'extends Backbone.Model', ->
        model = new Model()
        expect(model).toBeInstanceOf Model
        expect(model).toBeInstanceOf Backbone.Model

    describe '.parse', ->
      it 'dewraps returned data if there is a data property', ->
        parsedData = model.parse _successfulResposnse
        expect(parsedData.data).not.toBeDefined()
        expect(parsedData.status).not.toBeDefined()
        expect(parsedData.name).toEqual _data.name
      it 'returns the original response if there is no data property', ->
        parsedData = model.parse _unwrappedResponse
        expect(parsedData.data).not.toBeDefined()
        expect(parsedData.name).toEqual _data.name
      it 'implements `dewrap` so that you can implement your own parse if you want to', ->
        MyModel = Model.extend
          parse: (resp) ->
            resp = @dewrap resp
            resp.nameAndEmail = "#{resp.name} - #{resp.email}"
            resp
        mine = new MyModel _successfulResposnse, parse:true
        expect(mine.attributes.name).toEqual _data.name
        expect(mine.attributes.nameAndEmail).toBeDefined()
        expect(mine.attributes.nameAndEmail).toContain _data.name
        expect(mine.attributes.nameAndEmail).toContain _data.email





    describe '.increment', ->
      it 'increments model value if the value is a number', ->
        expect(model.attributes.visits).toEqual _data.visits
        model.increment 'visits'
        expect(model.attributes.visits).toEqual _data.visits + 1
      it 'doesn\'t do anything if the value isn\'t a number', ->
        expect(model.attributes.name).toEqual _data.name
        model.increment 'name'
        expect(model.attributes.name).toEqual _data.name

