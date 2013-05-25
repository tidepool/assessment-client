define [
  'underscore'
  'backbone'
  './user_menu'
],
(
  _
  Backbone
  userMenu
) ->

  _fakeUser =
    name: 'Billy Bob Thorton'
  _fakeUser2 =
    name: 'Kevin Bacon'

  beforeEach ->
    jasmine.getFixtures().set sandbox() # Set up an empty #sandbox div that gets cleaned up after every test

  describe 'ui_widgets/user_menu', ->
    it 'exists', ->
      expect(userMenu).toBeDefined()
    it 'creates the expected markup by default', ->
      $sandbox = $('#sandbox')
      expect($sandbox).toBeEmpty()
      $sandbox.html userMenu.el
      expect($sandbox).not.toBeEmpty()
      expect($sandbox).toContain '.userMenu'
    it 'is instantiated by default', ->
      expect(typeof userMenu).toEqual("object")

    describe 'it uses a .start() method', ->
      it 'has a .start method', ->
        expect(userMenu.start).toBeDefined()
      it 'expects the .start method to sent an appInstance', ->
        expect( -> userMenu.start()).toThrow()
      it 'populates its model through the start method', ->
        userMenu.start
          user: new Backbone.Model()
        expect(userMenu.model).toBeDefined()
        expect(userMenu.model).toBeInstanceOf(Backbone.Model)

    describe 'it builds itself based on a model', ->
      it 'renders itself with model data', ->
        userMenu.start
          user: new Backbone.Model _fakeUser
        $('#sandbox').html userMenu.el
        expect($('#sandbox')).toContainText _fakeUser.name

      it 're-renders when its model changes', ->
        userMenu.start
          user: new Backbone.Model _fakeUser
        $sandbox = $('#sandbox')
        $sandbox.html userMenu.el
        expect($sandbox).toContainText _fakeUser.name
        expect($sandbox).not.toContainText _fakeUser2.name
        userMenu.model.set _fakeUser2
        expect($sandbox).toContainText _fakeUser2.name
