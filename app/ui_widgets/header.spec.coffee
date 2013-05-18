define [
  'underscore'
  'Backbone'
  './header'
],
(
  _
  Backbone
  Header
) ->

  _factory = ->
    spoofSession =
      loggedIn: -> true
    _.extend spoofSession, Backbone.Events
    new Header
      app: _.extend {}, Backbone.Events
      session: spoofSession

  beforeEach ->
    jasmine.getFixtures().set sandbox() # Set up an empty #sandbox div that gets cleaned up after every test

  describe 'ui_widgets/header', ->

    it 'exists', ->
      expect(Header).toBeDefined()

    it 'enforces instantiation in a certain way', ->
      expect( -> new Header() ).toThrow()
      header = _factory()
      expect(header).toBeInstanceOf Header

    it 'creates the expected markup', ->
      $sandbox = $('#sandbox')
      expect($sandbox).toBeEmpty()
      header = _factory()
      $sandbox.html header.render().el
      expect($sandbox).not.toBeEmpty()
      expect($sandbox).toContain('.logo')
      expect($sandbox).toContain('header')

    it 'shows the nav by default', ->
      $sandbox = $('#sandbox')
      header = _factory()
      $sandbox.html header.render().el
      expect($sandbox).toContain('nav')

    it 'can control nav display using .showNav() and .hideNav()', ->
      $sandbox = $('#sandbox')
      header = _factory()
      $sandbox.html header.render().el
      expect($sandbox).toContain('nav')
      header.hideNav().render()
      expect($sandbox).not.toContain('nav')
      header.showNav().render()
      expect($sandbox).toContain('nav')
