define [
  'underscore'
  'backbone'
  './collection'
  './model'
],
(
  _
  Backbone
  Collection
  Model
) ->

  _p1 =
    name: 'Lars'
    email: 'lars@gmail.com'
    visits: 42
  _p2 =
    name: 'Susan'
    email: 'susan@gmail.com'
    visits: 12
  _data = [ _p1, _p2 ]
  _successfulResposnse =
    status: {}
    data: _data
  _unwrappedResponse = _data


  describe 'classes/collection', ->
    collection = null # get it in scope

    beforeEach ->
      collection = new Collection _successfulResposnse, parse:true

    describe 'the basics', ->
      it 'extends Backbone.Collection', ->
        expect(collection).toBeInstanceOf Collection
        expect(collection).toBeInstanceOf Backbone.Collection
      it 'uses our custom model', ->
        expect(collection.model).toBeInstanceOf Model

    describe '.parse', ->
      it 'uses the same dewrap method as the Model', ->
        expect(collection.dewrap).toEqual Model.prototype.dewrap
      it 'uses the same parse method as the Model', ->
        expect(collection.parse).toEqual Model.prototype.parse
      it 'dewraps returned data if there is a data property', ->
        expect(collection.at(0).attributes.name).toEqual _p1.name



