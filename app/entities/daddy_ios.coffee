define [
  'utils/detect'
], (
  detect
) ->

  _urlAction = "iosaction"
  _urlLog = "ioslog"
  _noOp = -> @


  Export = (options) ->
    # Only use these methods for ui web views
    if detect.isUIwebView() or options?.force
      @isUp = true
    else
      @save = @cleanUp = _noOp
    @


  Export.prototype =

    # Save data using an iframe.
    # msg: a string to send to IOS
    # skipCleanup: if true, don't remove the iframe. used for unit testing
    # urlRoot: optional. If set, changes the URL root. Useful for telling IOS to treat the message differently
    holla: (msg, skipCleanup, urlRoot) ->
      root = urlRoot || _urlAction
      @iframe = @iframe || document.createElement "IFRAME"
      @iframe.setAttribute 'src', "#{root}://#{msg}"
      document.documentElement.appendChild @iframe
      @cleanUp unless skipCleanup
      @

    log: (msg, skipCleanup) ->
      @holla msg, skipCleanup, _urlLog

    cleanUp: ->
      return unless @iframe?
      @iframe.parentNode.removeChild @iframe
      delete @iframe
      @


  Export

