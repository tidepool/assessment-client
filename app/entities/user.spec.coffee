define [
  './user'
],
(
  User
) ->

  _testEmail = 'test@abc.com'

  describe 'entities/user', ->

    it 'should return isGuest is true if the user is guest', ->
      user = new User guest:true
      expect(user.isGuest()).toBe true

    describe 'it creates a nickname', ->
      it 'sets the nickname to email if that is provided', ->
        user = new User email: _testEmail
        expect(user.get('nickname')).toEqual _testEmail

