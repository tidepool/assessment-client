define [
  'backbone'
  './daddy_ios'
],
(
  Backbone
  Ios
) ->

  _userName = 'Bob Bohanabranson'
  _iosLogProtocol = 'ioslog'
  _iosErrorProtocol = 'ioserr'
  _nonsensicalProtocol = 'borgTranslation'
  _fakeErrMsg = 'This sputnik has flown the coop'

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
        ios.holla _userName, true # true = skip cleanup. Not the typical usage, but allows for testing the iframe
        expect($('iframe')).toHaveLength 1
        expect($('iframe').attr('src').indexOf _userName).not.toEqual -1
        ios.cleanUp()
        expect($('iframe')).toHaveLength 0
      it 'supports sending with any protocol as the 3rd param', ->
        ios.holla _userName, true, _nonsensicalProtocol
        expect($('iframe')).toHaveLength 1
        expect($('iframe').attr('src').indexOf _nonsensicalProtocol).not.toEqual -1
        ios.cleanUp()
        expect($('iframe')).toHaveLength 0

#    describe 'log', ->
#      it 'log data to ios with a different protocol', ->
#        ios.log _userName, true
#        expect($('iframe')).toHaveLength 1
#        expect($('iframe').attr('src').indexOf _userName).not.toEqual -1
#        expect($('iframe').attr('src').indexOf _iosLogProtocol).not.toEqual -1
#        ios.cleanUp()
#        expect($('iframe')).toHaveLength 0
#
#    describe 'error', ->
#      it 'sends error messages to ios', ->
#        ios.error _fakeErrMsg, true
#        expect($('iframe')).toHaveLength 1
#        expect($('iframe').attr('src').indexOf _fakeErrMsg).not.toEqual -1
#        expect($('iframe').attr('src').indexOf _iosErrorProtocol).not.toEqual -1
#        ios.cleanUp()
#        expect($('iframe')).toHaveLength 0

