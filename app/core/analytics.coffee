define [],() ->
  _me = 'core/analytics'
  Analytics = (cfg) ->
    throw new Error('Need arguments[0].googleAnalyticsKey') unless cfg.googleAnalyticsKey
    console.log "Created #{_me}"
    # Google code run through js2coffee.org
    _gaq = [["_setAccount", cfg.googleAnalyticsKey], ["_trackPageview"]]
    ((d, t) ->
      g = d.createElement(t)
      s = d.getElementsByTagName(t)[0]
      g.src = ((if "https:" is location.protocol then "//ssl" else "//www")) + ".google-analytics.com/ga.js"
      s.parentNode.insertBefore g, s
    ) document, "script"
    @

  Analytics

