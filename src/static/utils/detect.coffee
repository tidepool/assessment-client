define [
  'jquery'
], (
  $
) ->

  _phoneWidth = 603
  _tabletWidth = 1024

  # Utility Methods for doing feature detection
  detect =
    # http://stackoverflow.com/questions/4817029/whats-the-best-way-to-detect-a-touch-screen-device-using-javascript
    isTouch: -> !!('ontouchstart' of window) or !!('onmsgesturechange' of window) # most browsers || ie10 surface
    # http://stackoverflow.com/questions/4460205/detect-ipad-iphone-webview-via-javascript
    isUIwebView: -> /(iPhone|iPod|iPad).*AppleWebKit(?!.*Safari)/i.test navigator.userAgent


    # --------------------------------------------------------------- Size Detection
    isPhone: ->         window.matchMedia?("(max-width: #{_phoneWidth}px)").matches
    isPhoneOrTablet: -> window.matchMedia?("(max-width: #{_tabletWidth}px)").matches
#      tabletWidth = 1024
#      $(window).width() <= tabletWidth


  detect
