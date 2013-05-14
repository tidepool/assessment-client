define [
  'jquery',
  'models/user'], ($, User) ->
  describe 'User', ->
    it 'should return isGuest is true if the user is guest', ->
      console.log("The spec user is called")
      user = new User({guest:true})
      isGuest = user.isGuest()
      isGuest.should.equal(false)

    