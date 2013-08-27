define [
  'backbone'
  './daddy_ios'
],
(
  Backbone
  ios
) ->

  _goodMessage =
    type: ios.TYPES.log
    message: 'The Rain in Spain Stays Mainly in the Plain'
    details: 'This is because the elevated elevation and nearby coastline creates a convenient location for atmospheric humidity to disperse.'

  _badMessage =
    type: null

  ios.forceOn() # Normally it would be inactive, since this object is for communicating with a native IOS parent.

  _checkIFrame = (expectedContent) ->
    expect($('iframe')).toHaveLength 1
    expect($('iframe').attr('src').indexOf expectedContent).not.toEqual -1

  describe 'entities/daddy_ios', ->

    it 'exists', ->
      expect(ios).toBeDefined()

    it '.isUp', ->
      expect(ios.isUp).toBeTruthy()

    describe 'holla', ->
      it 'creates an iframe as a way to holla data to ios', ->
        ios.holla _goodMessage, true # true = skip cleanup. Not the typical usage, but allows for testing the iframe
        _checkIFrame _goodMessage.message
        ios.cleanUp()
        expect($('iframe')).toHaveLength 0
      it 'will not send a message if it is missing a type', ->
        ios.holla _badMessage, true
        expect($('iframe')).toHaveLength 0

    describe 'start', ->
      it 'sends a start message to ios', ->
        ios.start true # true = skip cleanup
        _checkIFrame ios.TYPES.start
        ios.cleanUp()
        expect($('iframe')).toHaveLength 0
#      it 'is a chainable method', ->
#        ios.start().log 'hello', true
#        _checkIFrame 'hello'
#        ios.cleanUp()
#        expect($('iframe')).toHaveLength 0

    describe 'finish', ->
      it 'sends a finish message to ios', ->
        ios.finish true
        _checkIFrame ios.TYPES.finish
        ios.cleanUp()

    describe 'log', ->
      it 'sends message to ios', ->
        ios.log _goodMessage.message, null, true # msg, detail, skipCleanup
        _checkIFrame ios.TYPES.log
        _checkIFrame _goodMessage.message
        ios.cleanUp()

    describe 'warn', ->
      it 'sends message to ios', ->
        ios.warn _goodMessage.message, null, true # msg, detail, skipCleanup
        _checkIFrame ios.TYPES.warn
        _checkIFrame _goodMessage.message
        ios.cleanUp()
      it 'supports both a user message and details', ->
        ios.warn _goodMessage.message, _goodMessage.details, true # msg, detail, skipCleanup
        _checkIFrame ios.TYPES.warn
        _checkIFrame _goodMessage.message
        _checkIFrame _goodMessage.details
        ios.cleanUp()

    describe 'error', ->
      it 'sends message to ios', ->
        ios.error _goodMessage.message, null, true # msg, detail, skipCleanup
        _checkIFrame ios.TYPES.error
        _checkIFrame _goodMessage.message
        ios.cleanUp()

