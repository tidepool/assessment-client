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
    UserVoice.start()
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
      try
        @kiss?.track "#{category}:#{action}", data
      catch err
        console.warn 'Error Logging to Kiss'
        console.log err
      # ------------------------------------------------------ v Line of Awesome
#      console.log category:category, action:action # Uncomment this to view real-time details
      # ------------------------------------------------------ ^ Line of Awesome






  Analytics

