define [
  'underscore'
  'Backbone'
  'user/profile_dialog'
],
(
  _
  Backbone
  Profile
) ->

  _myClassName = '.profileDialog'

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

  beforeEach ->
    jasmine.getFixtures().set sandbox() # Set up an empty #sandbox div that gets cleaned up after every test

  describe 'views/user/profile_dialog', ->

    it 'exists', ->
      expect(Profile).toBeDefined()

    it '.show makes it show up and add expected content to the dom', ->
      p = new Profile
        user: _mockUser()
      p.show()
      waits 200
      runs ->
        expect($('body')).toContain _myClassName
        expect($(_myClassName)).toContainText _mockUser.name
        p.close()
      waits 200

    it '.close hides it', ->
      p = new Profile
        user: _mockUser()
      p.show()
      waits 200
      runs ->
        expect($(_myClassName)).toBeVisible()
        p.close()
      waits 200
      runs ->
        expect($(_myClassName)).not.toBeVisible()









