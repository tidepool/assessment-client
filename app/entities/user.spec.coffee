define [
  './user'
],
(
  User
) ->


  _loginValid =
    email: 'bob@123.com'
    password: 'asdfasdf'
  _loginMissingEmail =
    password: ''
  _loginMissingPass =
    email: 'bob@123.com'
  _loginShortPass =
    email: 'bob@123.com'
    password: 'eric'
  _regUnmatchedPass =
    email: 'colin@meloy.com'
    password: 'asdfasdf'
    passwordConfirm: ';lkj;lkj'
  _regValid =
    email: 'colin@meloy.com'
    password: 'asdfasdf'
    passwordConfirm: 'asdfasdf'


  _testEmail = 'test@abc.com'

  describe 'entities/user', ->

    it 'should return isGuest is true if the user is guest', ->
      user = new User guest:true
      expect(user.isGuest()).toBe true


    describe 'login validation', ->

      it 'is valid with an email and a password', ->
        user = new User _loginValid
        expect( user.isValid( login:true ) ).toBe true

      it 'is not valid without an email', ->
        user = new User _loginMissingEmail
        expect( user.isValid( login:true ) ).not.toBe true

      it 'is not valid without a password', ->
        user = new User _loginMissingPass
        expect( user.isValid( login:true ) ).not.toBe true

      it 'is not valid with a short password', ->
        user = new User _loginShortPass
        expect( user.isValid( login:true ) ).not.toBe true


    describe 'register validation', ->

      it 'needs more than login information', ->
        user = new User _loginValid
        expect( user.isValid( register:true ) ).not.toBe true

      it 'can tell if the passwords don\'t match', ->
        user = new User _regUnmatchedPass
        expect( user.isValid( register:true ) ).not.toBe true

      it 'validates if you send it all the right stfs', ->
        user = new User _regValid
        expect( user.isValid( register:true ) ).toBe true