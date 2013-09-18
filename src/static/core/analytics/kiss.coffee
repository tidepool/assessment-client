define [],() ->


  # ----------------------------------------------------------- Constructor
  Kiss = (key) ->
    window._kms = (u) ->
      setTimeout (->
        d = document
        f = d.getElementsByTagName("script")[0]
        s = d.createElement("script")
        s.type = "text/javascript"
        s.async = true
        s.src = u
        f.parentNode.insertBefore s, f
      ), 1
    window._kmq = window._kmq or []
    window._kmk = window._kmk or key
    window._kms "https://i.kissmetrics.com/i.js"
    window._kms "https://doug1izaerwt3.cloudfront.net/" + window._kmk + ".1.js"
    @ #constructor returns `this`


  Kiss.prototype =

    # ----------------------------------------------------------- The Basics
    track: (eventName, props) ->
      window._kmq.push [
        'record'
        eventName
        props
      ]

#    setUser = (humanreadableUserKey) ->
#      if _kmq?
#    #      console.log "_setUser(#{humanreadableUserKey})"
#        _kmq.push [
#          'identify'
#          humanreadableUserKey
#        ]
#      else
#        setTimeout (=> @setUser(humanreadableUserKey)), 250

#    clearUser: ->
#      _kmq.push ['clearIdentity']



  Kiss
