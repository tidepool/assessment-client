define [],() ->


  # ----------------------------------------------------------- Constructor
  GoogleAnalytics = (key, isDev) ->
    # New method of GA tracking (early 2013)
    # https://developers.google.com/analytics/devguides/collection/analyticsjs/advanced
    ((i, s, o, g, r, a, m) ->
      i["GoogleAnalyticsObject"] = r
      i[r] = i[r] or ->
        (i[r].q = i[r].q or []).push arguments
      i[r].l = 1 * new Date()
      a = s.createElement(o) ; m = s.getElementsByTagName(o)[0]
      a.async = 1 ; a.src = g ; m.parentNode.insertBefore a, m
    ) window, document, "script", "//www.google-analytics.com/analytics.js", "ga"
    if isDev
      ga "create", key, "tide-dev.herokuapp.com"
    else
      ga "create", key


  GoogleAnalytics.prototype =

    # ----------------------------------------------------------- The Basics
    trackPage: (pageName) ->
      ga 'send', 'pageview',
        location: document.URL
        page: "/#{pageName}" # Must start with `/`

    # https://developers.google.com/analytics/devguides/collection/analyticsjs/field-reference#create
    trackEvent: (category, action) ->
      #console.log 'tracking to ga'
      ga 'send', 'event',
        eventCategory: category
        eventAction: action
        #eventLabel: ''
        #eventValue: ''

    # TODO: Measure load times
    # https://developers.google.com/analytics/devguides/collection/analyticsjs/user-timings


    # ----------------------------------------------------------- Custom Dimensions and Metrics

    # Set the first visit date of the user. Uses the format `YYYYMMDD` for best cohort tracking
    # http://cutroni.com/blog/2012/12/11/cohort-analysis-with-google-analytics/
    setFirstVisit: ->
      date = new Date()
      y = date.getFullYear()
      m = date.getMonth() + 1 # JS 0 indexes months for some reason
      d = date.getDate()
      if m.length is 1 then m = "0#{m}"
      if d.length is 1 then d = "0#{d}"
      ga('set', 'dimension1', y+m+d) #this `dimension1` is determined by the Google Analytics web GUI

    setGamesPlayed: (gameCount) ->
      ga('set', 'metric1', gameCount)




  GoogleAnalytics
