define [
  'backbone'
  './daddy_ios'
],
(
  Backbone
  Ios
) ->

  _testData =
    userName: 'Bob Bohanabranson'
    userId: 42
    pi: Math.PI

  describe 'entities/daddy_ios', ->
    ios = null

    beforeEach ->
      ios = new Ios force:true # as in: force it to exist. usually this object is only active for uiwebviews

    it 'exists', ->
      expect(Ios).toBeDefined()

    it '.isUp', ->
      expect(ios.isUp).toBeTruthy()

    describe 'holla', ->
      it 'creates an iframe as a way to holla data to ios', ->
        ios.holla _testData, true # true = skip cleanup. Not the typical usage, but allows for testing the iframe
        expect($('iframe')).toHaveLength 1
        expect($('iframe').attr('src').indexOf _testData.userName).not.toEqual -1
        ios.cleanUp()
        expect($('iframe')).toHaveLength 0




