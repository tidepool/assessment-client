define [
  'underscore'
  'backbone'
  './profile_dialog'
],
(
  _
  Backbone
  Profile
) ->

  _myClassName = '.profileDialog'
  _animationTime = 300

  _mockUser = ->
    new Backbone.Model
      name: 'Jimmy Buffet'
      email: 'jjb@musicians.net'
      gender: 'male'
      dob: '6/25/1960'
      timezone: '-7'
      city: 'San Francisco'
      state: 'California'
      country: 'United States'

  _factory = ->
    new Profile
      model: _mockUser()

  beforeEach ->
    jasmine.getFixtures().set sandbox() # Set up an empty #sandbox div that gets cleaned up after every test

  describe 'views/user/profile_dialog', ->

    it 'exists', ->
      expect(Profile).toBeDefined()

    it 'instantiation makes it show up and add expected content to the dom', ->
      p = _factory()
      waits _animationTime
      runs ->
        expect($('body')).toContain _myClassName
        expect($(_myClassName)).toContainText _mockUser.name
        p.hide()
      waits _animationTime

    it '.hide hides it', ->
      p = _factory()
      waits _animationTime
      runs ->
        expect($(_myClassName)).toBeVisible()
        p.hide()
      waits _animationTime
      runs ->
        expect($(_myClassName)).not.toBeVisible()









