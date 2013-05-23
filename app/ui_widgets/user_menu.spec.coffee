define [
  'underscore'
  'Backbone'
  './user_menu'
],
(
  _
  Backbone
  userMenu
) ->

  _fakeUser =
    showUser: true
    isRegisteredUser: true
    userName: 'Billy Bob Thorton'

  beforeEach ->
    jasmine.getFixtures().set sandbox() # Set up an empty #sandbox div that gets cleaned up after every test

  describe 'ui_widgets/user_menu', ->

    it 'exists', ->
      expect(userMenu).toBeDefined()

    it 'requires an app object in order to be instantiated', ->
      expect

    it 'creates the expected markup by default', ->
      $sandbox = $('#sandbox')
      expect($sandbox).toBeEmpty()
      $sandbox.html userMenu.el
      expect($sandbox).not.toBeEmpty()
      expect($sandbox).toContain '.userMenu'

    it 'has a .start method. Giving it a model makes it render. When the model changes it re-renders', ->
      $sandbox = $('#sandbox')
      $sandbox.html userMenu.el
      expect(userMenu.start).toBeDefined()
      userMenu.start new Backbone.Model _fakeUser
      expect($sandbox).toContainText(_fakeUser.userName)
      userMenu.model.set 'userName', 'Kevin Bacon'
      expect($sandbox).toContainText 'Kevin Bacon'

