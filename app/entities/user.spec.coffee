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


