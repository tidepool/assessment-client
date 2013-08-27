define [
  'utils/detect'
], (
  detect
) ->


  _TYPES =
    start: 'start'
    finish:'finish'
    log:   'log'
    warn:  'warn'
    error: 'error'


  Export = ->
    # Only use these methods for ui web views
    if detect.isUIwebView()
      @isUp = true
    @


  Export.prototype =
    # Save data using an iframe.
    # msg: An object to send to ios. Must be in a particular message format
    # skipCleanup: if true, don't remove the iframe. used for unit testing
    holla: (msgObject, skipCleanup) ->
      return @ unless @isUp
      if @_validate msgObject
        console.warn @_validate msgObject
        return @
      @iframe = @iframe || document.createElement "IFRAME"
#      console.log msgObject:msgObject
      src = 'ios://' + JSON.stringify msgObject
      @iframe.setAttribute 'src', src
      document.documentElement.appendChild @iframe
      @cleanUp() unless skipCleanup
      @

    _validate: (message) ->
      return "message.type is required" unless message.type?
      null


    # ----------------------------------------------------------------- Testing Helpers
    forceOn: -> @isUp = true
    cleanUp: ->
      return unless @iframe?
      @iframe.parentNode.removeChild @iframe
      delete @iframe
      @


    # ----------------------------------------------------------------- API meant for consumption
    TYPES: _TYPES
    start:  (skipCleanup) ->      @holla { type:_TYPES.start  }, skipCleanup
    finish: (skipCleanup) ->      @holla { type:_TYPES.finish }, skipCleanup
    log:    (msg, detail, skipCleanup) -> @holla { type:_TYPES.log,   usrMsg:msg, logMsg:detail }, skipCleanup
    warn:   (msg, detail, skipCleanup) -> @holla { type:_TYPES.warn,  usrMsg:msg, logMsg:detail }, skipCleanup
    error:  (msg, detail, skipCleanup) -> @holla { type:_TYPES.error, usrMsg:msg, logMsg:detail }, skipCleanup

  new Export

