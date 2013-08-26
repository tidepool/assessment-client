define [
  'underscore'
  'backbone'
  './login'
],
(
  _
  Backbone
  Login
) ->

  _myClassName = '.loginDialog'

  _mockUser = ->
    new Backbone.Model
      email: 'jjb@musicians.net'
      gender: 'male'

  _factory = ->
    new Login
      model: _mockUser()
      app:
        session:
          register: -> true
          signIn: -> true
        user:
          isGuest: -> true

  beforeEach ->
    jasmine.getFixtures().set sandbox() # Set up an empty #sandbox div that gets cleaned up after every test

  describe 'forms/user/login', ->

    it 'exists', ->
      expect(Login).toBeDefined()

    it 'throws an error if not instantiated properly', ->
      expect( -> new Login()).toThrow()

    describe 'it can log in or register', ->

      it 'starts in log in mode', ->
        login = _factory()
        $('#sandbox').html login.render().el
        expect($('body')).toContain _myClassName
        expect( $("[name='passwordConfirm']") ).not.toBeVisible()
        expect( $("[name='loginType']") ).toHaveValue 'signIn'

      it 'can switch to register mode', ->
        login = _factory()
        $('#sandbox').html login.render().el
        expect($('body')).toContain _myClassName
        $("#ActionRegister").click()
        expect( $("[name='passwordConfirm']") ).toBeVisible()
        expect( $("[name='loginType']") ).toHaveValue 'register'





