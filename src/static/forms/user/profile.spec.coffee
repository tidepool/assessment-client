define [
  'underscore'
  'backbone'
  './profile'
],
(
  _
  Backbone
  Profile
) ->

  _myClassName = '.userProfile'

  _mockUser = ->
    new Backbone.Model
      name: 'Jimmy Buffet'
      email: 'jjb@musicians.net'
      gender: 'male'
      handedness: [ 'left', 'right' ]
      education: 'Salt Life'
      timezone: '-7'
      city: 'San Francisco'
      state: 'California'
      country: 'United States'

  _valByName = (name) ->
    $('#sandbox').find("input[name='#{name}']").val()

  _factory = ->
    new Profile
      model: _mockUser()

  beforeEach ->
    jasmine.getFixtures().set sandbox() # Set up an empty #sandbox div that gets cleaned up after every test

  describe 'forms/user/profile', ->

    it 'exists', ->
      expect(Profile).toBeDefined()

    it 'instantiation creates a backbone view that can be put in the dom', ->
      $('#sandbox').html _factory().render().el
      expect($('#sandbox')).toContain _myClassName

    it 'creates a name field that has our user\'s name in it', ->
      $('#sandbox').html _factory().render().el
      expect( _valByName('name') ).toEqual _mockUser().attributes.name


