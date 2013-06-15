define [],() ->
  _me = 'core/analytics'


  # --------------------------------------------------------------------------- Analytics Initial Setup Methods
  # Google Analtyics
  _setUpGoogle = (key) ->
    _gaq = _gaq or []
    _gaq.push ["_setAccount", key]
    _gaq.push ["_setDomainName", "tidepool.co"]
    _gaq.push ["_setAllowLinker", true]
    (->
      ga = document.createElement("script")
      ga.type = "text/javascript"
      ga.async = true
      ga.src = ((if "https:" is document.location.protocol then "https://ssl" else "http://www")) + ".google-analytics.com/ga.js"
      s = document.getElementsByTagName("script")[0]
      s.parentNode.insertBefore ga, s
    )()


  # Kiss Metrics
  _setUpGeneSimmons = (key) ->
    _kms = (u) ->
      setTimeout (->
        d = document
        f = d.getElementsByTagName("script")[0]
        s = d.createElement("script")
        s.type = "text/javascript"
        s.async = true
        s.src = u
        f.parentNode.insertBefore s, f
      ), 1
    _kmq = _kmq or []
    _kmk = _kmk or key
    _kms "//i.kissmetrics.com/i.js"
    _kms "//doug1izaerwt3.cloudfront.net/" + _kmk + ".1.js"


  # --------------------------------------------------------------------------- Private Static Methods
  _trackKiss = (eventName, props) ->
    return unless eventName? and _kmq?
    #console.log 'tracking to kiss'
    _kmq.push [
      'record'
      eventName
      props
    ]

  _trackGooglePageView = (eventName) ->
    return unless eventName? and _gaq?
    #console.log 'tracking to ga'
    _gaq.push [
      '_trackPageview'
    ]

  # https://developers.google.com/analytics/devguides/collection/gajs/eventTrackerGuide
  _trackGoogleEvent = (category, action, label, value) ->
    return unless eventName? and _gaq?
    #console.log 'tracking to ga'
    _gaq.push [
      '_trackEvent'
      category
      action
      label
      value
    ]

  _setUser = (humanreadableUserKey) ->
    if _kmq?
      _kmq.push [
        'identity'
        humanreadableUserKey
      ]












  # Constructor
  Analytics = (cfg) ->
    #cfg.debug && console.log "Created #{_me}"
    _setUpGoogle(cfg.googleAnalyticsKey) if cfg.googleAnalyticsKey
    _setUpGeneSimmons(cfg.kissKey) if cfg.kissKey

    # Track all javascript errors
    window.onerror = (msg, url, lineNumber) =>
      @track @CATEGORIES.jsErr, msg, url, lineNumber
      return false # let the default handler run, too

    return this

  # Prototype
  Analytics.prototype =

    CATEGORIES:
      viewPage: 'ViewPage: '
      viewLightbox: 'ViewLightbox: '
      jsErr: 'JS Error: '
      serverError: 'Server Error: '

    # --------------------------------------------------------------------------- Public API
    trackPage: (name) ->
      _trackGooglePageView name
      _trackKiss @CATEGORIES.viewPage + name

    track: (category, action, label, value) ->
      return unless category? and action?
      _trackGoogleEvent(category, action, label, value)
      if label and value
        _trackKiss("#{category}:#{action}", { label:label, value:value})
      else
        _trackKiss("#{category}:#{action}")

    # Called once we know who the user is
    setUserIdentity: (humanreadableUserKey) ->
      return unless humanreadableUserKey?
      _setUser humanreadableUserKey

    # `prop` should be an object with a property and a value
#    setUserProp: (prop) ->
#      # http://support.kissmetrics.com/apis/javascript/javascript-specific/
#      if _kmq?
#        _kmq.push [
#            'set', prop
#          ]

#    clearUser: ->
#      _kmq.push ['clearIdentity']


  Analytics

