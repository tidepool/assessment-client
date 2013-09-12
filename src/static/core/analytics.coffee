define [
  './analytics/google'
  './analytics/kiss'
  './analytics/uservoice'
  'utils/detect'
  'utils/numbers'
],(
  Google
  Kiss
  UserVoice
  detect
  numbers
) ->
  _me = 'core/analytics'


  # Constructor
  Analytics = (cfg) ->
    @google = new Google(cfg.googleAnalyticsKey, cfg.isDev) if cfg.googleAnalyticsKey
    @kiss = new Kiss(cfg.kissKey) if cfg.kissKey
    UserVoice.start() unless detect.isUIwebView()
    # Track all javascript errors
    window.onerror = (msg, url, lineNumber) =>
      @trackKeyMetric @CATEGORIES.jsErr, msg, {url:lineNumber}
      return false # let the default handler run, too
    @


  Analytics.prototype =
    # --------------------------------------------------------------------------- Public API
    CATEGORIES:
      viewPage: 'ViewPage'
      viewLightbox: 'ViewLightbox'
      jsErr: 'JS Error'
      serverError: 'Server Error'

    trackPage: (name) ->
      return unless name?
      @google?.trackPage name
#      @kiss?.track @CATEGORIES.viewPage + name

    track: (category, action, label, value) ->
      return unless category? and action?
      @google?.trackEvent category, action, label, value
      # ------------------------------------------------------ v Line of Awesome
      #console.log category:category, action:action, label:label, value:value # Uncomment this to view real-time details of every analytics event send to .track
      # ------------------------------------------------------ ^ Line of Awesome

    trackKeyMetric: (category, action, data) ->
      return unless category? and action?
      @google?.trackEvent category, action
      @kiss?.track "#{category}:#{action}", data
      # ------------------------------------------------------ v Line of Awesome
#      console.log category:category, action:action # Uncomment this to view real-time details
      # ------------------------------------------------------ ^ Line of Awesome

    # Compares a given time to the start of page loading, and tracks the difference
    trackPerformance: (coreLoadedTime) ->
      data =
        entryPage:  window.location.protocol + '//' + window.location.hostname + window.location.hash
        jsLoadTime: coreLoadedTime - window.pageLoadStart if window.pageLoadStart

      # If the new performance api is aviailable, log that stuff too
      if performance?.timing? and numbers.casino(.1) #Only track a percentage of the time
        data.latency =       performance.timing.responseEnd  - performance.timing.fetchStart
        data.pageLoad =      performance.timing.loadEventEnd - performance.timing.responseEnd
        data.totalLoadTime = performance.timing.loadEventEnd - performance.timing.navigationStart
        data.jsLoadTime =    coreLoadedTime - performance.timing.navigationStart
        # Track the data unless performance is less than zero. This happens if the performance.timing numbers haven't come in yet (eg: null - (new Date()).getTime())
        @kiss?.track        'performance', data unless data.jsLoadTime < 0
        @google?.trackEvent 'performance', 'log', 'latency',    data.latency    unless data.latency < 0
        @google?.trackEvent 'performance', 'log', 'pageLoad',   data.pageLoad   unless data.pageLoad < 0
        @google?.trackEvent 'performance', 'log', 'jsLoadTime', data.jsLoadTime unless data.jsLoadTime < 0
      # Always log jsLoadTime
      else
        @kiss?.track        'performance', data unless data.jsLoadTime < 0
        @google?.trackEvent 'performance', 'log', 'jsLoadTime', data.jsLoadTime unless data.jsLoadTime < 0





  Analytics

