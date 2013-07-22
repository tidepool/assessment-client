define [], () ->


  # Utility Methods for doing feature detection
  detect =
    # http://stackoverflow.com/questions/4817029/whats-the-best-way-to-detect-a-touch-screen-device-using-javascript
    isTouch: -> !!('ontouchstart' of window) or !!('onmsgesturechange' of window) # most browsers || ie10 surface


  detect
