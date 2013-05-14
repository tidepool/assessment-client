define [
  './user'
],
(
  User
) ->
  describe 'User', ->
    it 'should return isGuest is true if the user is guest', ->
      user = new User
        guest:true
      expect(user.isGuest()).toBe true

    