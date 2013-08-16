define [
  'utils/detect'
], (
  detect
) ->

  _urlRoot = "iosaction://"
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
    # Support skipping so that unit testing can observe the iframe before cleaning it up
    holla: (data, skipCleanup) ->
      @iframe = @iframe || document.createElement "IFRAME"
      @iframe.setAttribute 'src', "#{_urlRoot}#{JSON.stringify data}"
      console.log iosAction:JSON.stringify data
      document.documentElement.appendChild @iframe
      @cleanUp unless skipCleanup
      @

    cleanUp: ->
      return unless @iframe?
      @iframe.parentNode.removeChild @iframe
      delete @iframe
      @


  Export


