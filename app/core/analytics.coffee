define [
  './analytics/google'
  './analytics/kiss'
  './analytics/uservoice'
],(
  Google
  Kiss
  UserVoice
) ->
  _me = 'core/analytics'


  # Constructor
  Analytics = (cfg) ->
    @google = new Google(cfg.googleAnalyticsKey, cfg.isDev) if cfg.googleAnalyticsKey
    @kiss = new Kiss(cfg.kissKey) if cfg.kissKey
    console.log 'kiss instantiated'
    UserVoice.start()
    @trackPerformance()
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

    track: (category, action) ->
      return unless category? and action?
      @google?.trackEvent category, action
      # ------------------------------------------------------ v Line of Awesome
#      console.log category:category, action:action # Uncomment this to view real-time details of every analytics event send to .track
      # ------------------------------------------------------ ^ Line of Awesome

    trackKeyMetric: (category, action, data) ->
      return unless category? and action?
      @google?.trackEvent category, action
      @kiss?.track "#{category}:#{action}", data

      # ------------------------------------------------------ v Line of Awesome
#      console.log category:category, action:action # Uncomment this to view real-time details
      # ------------------------------------------------------ ^ Line of Awesome

    trackPerformance: (pageName) ->
      # Track page load times
      if performance?.timing?
        data =
          latency:       performance.timing.responseEnd  - performance.timing.fetchStart
          pageLoad:      performance.timing.loadEventEnd - performance.timing.responseEnd
          totalLoadTime: performance.timing.loadEventEnd - performance.timing.navigationStart
          entryPage:     window.location.protocol + '//' + window.location.hostname + window.location.hash
        console.log data
        @kiss?.track 'performance', data







  Analytics

