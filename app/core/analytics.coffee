define [],() ->
  _me = 'core/analytics'

  # Google Analtyics tracking snippet run through js2coffee.org
  _setUpGoogle = (key) ->
    _gaq = [["_setAccount", key], ["_trackPageview"]]
    ((d, t) ->
      g = d.createElement(t)
      s = d.getElementsByTagName(t)[0]
      g.src = ((if "https:" is location.protocol then "//ssl" else "//www")) + ".google-analytics.com/ga.js"
      s.parentNode.insertBefore g, s
    ) document, "script"
    @

  Analytics = (cfg) ->
    throw new Error('Need arguments[0].googleAnalyticsKey') unless cfg.googleAnalyticsKey
    cfg.debug && console.log "Created #{_me}"
    _setUpGoogle cfg.googleAnalyticsKey

  Analytics

