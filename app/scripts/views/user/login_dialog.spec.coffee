define [
  'underscore'
  'backbone'
  './login_dialog'
],
(
  _
  Backbone
  Dialog
) ->

  _myClassName = '.loginDialog'

  _mockUser = ->
    new Backbone.Model
      email: 'jjb@musicians.net'
      gender: 'male'

  beforeEach ->
    jasmine.getFixtures().set sandbox() # Set up an empty #sandbox div that gets cleaned up after every test

  describe 'views/user/login_dialog', ->

    it 'exists', ->
      expect(Dialog).toBeDefined()

    xit '.show makes it show up and add expected content to the dom', ->
      p = new Dialog
        app: _.extend {}, Backbone.Events
        model: _mockUser()
      p.show()
      waits 200
      runs ->
        expect($('body')).toContain _myClassName
        expect($(_myClassName)).toContainText _mockUser.name
        p.close()
      waits 200

    xit '.close hides it', ->
      p = new Dialog
        model: _mockUser()
      p.show()
      waits 200
      runs ->
        expect($(_myClassName)).toBeVisible()
        p.close()
      waits 200
      runs ->
        expect($(_myClassName)).not.toBeVisible()









