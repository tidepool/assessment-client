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
  _animationTime = 350

  _mockUser = ->
    new Backbone.Model
      email: 'jjb@musicians.net'
      gender: 'male'

  _factory = ->
    new Dialog
      model: _mockUser()
      app: {}

  describe 'views/user/login_dialog', ->

    it 'exists', ->
      expect(Dialog).toBeDefined()

    it 'throws an error if not instantiated properly', ->
      expect( -> new Dialog()).toThrow()

    it 'instantiation makes it show up and add expected content to the dom', ->
      login = _factory()
      waits _animationTime
      runs ->
        expect($('body')).toContain _myClassName
        expect($(_myClassName)).toContain 'input'
        login.hide()
      waits _animationTime

    it '.hide hides it', ->
      login = _factory()
      waits _animationTime
      runs ->
        expect($(_myClassName)).toBeVisible()
        login.hide()
      waits _animationTime
      runs ->
        expect($(_myClassName)).not.toBeVisible()

    describe 'it can log in or register', ->

      it 'starts in log in mode', ->
        login = _factory()
        waits _animationTime
        runs ->
          expect($('body')).toContain _myClassName
          expect( $("[name='passwordConfirm']") ).not.toBeVisible()
          expect( $("[name='loginType']") ).toHaveValue 'signIn'
          login.hide()
        waits _animationTime

      it 'can switch to register mode', ->
        login = _factory()
        waits _animationTime
        runs ->
          expect($('body')).toContain _myClassName
          $("#ActionRegister").click()
          expect( $("[name='passwordConfirm']") ).toBeVisible()
        waits 10
        runs ->
          expect( $("[name='loginType']") ).toHaveValue 'register'
          login.hide()
        waits _animationTime






