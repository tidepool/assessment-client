define [],() ->


  # ----------------------------------------------------------- Constructor
  Kiss = (key) ->
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


  Kiss.prototype =

    # ----------------------------------------------------------- The Basics
    track: (eventName, props) ->
      _kmq.push [
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
