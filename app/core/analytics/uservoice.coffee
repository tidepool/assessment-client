define [],() ->


  # ----------------------------------------------------------- Constructor
  UserVoice = {}
  UserVoice.start = (key) ->
    window.UserVoice = window.UserVoice or []
    #http://feedback.uservoice.com/knowledgebase/articles/171685-classic-widget-developer-documentation
    window.UserVoice.push ["showTab", "classic_widget",
      mode: "full"
      primary_color: "#eae8e5"
      link_color: "#188ff4"
      default_mode: "feedback"
      forum_id: 212724
      tab_label: "Feedback"
      tab_color: "#e43e45"
      tab_position: "bottom-left"
      tab_inverted: false
    ]
    uv = document.createElement("script")
    uv.type = "text/javascript"
    uv.async = true
    uv.src = "//widget.uservoice.com/heZnlXOU7JHatuDLyXHqw.js"
    s = document.getElementsByTagName("script")[0]
    s.parentNode.insertBefore uv, s

  UserVoice
