define [
  'backbone'
  'Handlebars'
  'text!./share.hbs'
  'entities/careBears/facebook'
  'entities/careBears/twitter'
  'entities/careBears/mailto'
  'core'
],
(
  Backbone
  Handlebars
  tmpl
  Facebook
  Twitter
  Email
  app
) ->

  _me = 'ui_widgets/share'
  _popoverSel = 'nav'
  _btnSel = '.btn'


  Me = Backbone.View.extend
    tagName: 'aside'
    className: 'share'
    events:
      click: "onClick"
      'click .action-facebook': 'onClickFacebook'
      'click .action-twitter': 'onClickTwitter'
      'click .action-email': 'onClickMailto'

    initialize: ->
      _.bindAll @, '_hide'

    render: ->
      @$el.html tmpl
      @


    # ---------------------------------------------------------------- Private Helper Methods
    _toggle: ->
      if @$(_popoverSel).is(':visible')
        @_hide()
      else
        @_show()

    _hide: ->
      @$(_btnSel).removeClass 'active'
      @$(_popoverSel).hide()

    _show: ->
      @$(_btnSel).addClass 'active'
      @$(_popoverSel).show()
      $('html').one 'click', @_hide


    # ---------------------------------------------------------------- Event Handlers
    onClick: (e) ->
      e.stopPropagation()
      @_toggle()

    onClickFacebook: (e) ->
      e.stopPropagation()
      @_hide()
      facebookShareBear = new Facebook
        picture: @options.data.image
        link: @options.data.link
        name: @options.data.title
        caption: @options.data.text
#        description: @options.data.text
      facebookShareBear.save()
      app.analytics.track @className, 'clicked facebook'

    onClickTwitter: (e) ->
      e.stopPropagation()
      @_hide()
      twitterShareBear = new Twitter
        text: "#{@options.data.title} -- "
        url: @options.data.link
      twitterShareBear.save()
      app.analytics.track @className, 'clicked twitter'

    onClickMailto: (e) ->
      e.stopPropagation()
      @_hide()
      email = new Email
        subject: @options.data.title
        body: @options.data.text
      email.save()
      app.analytics.track @className, 'clicked mailto'


    # ---------------------------------------------------------------- Public API




  Me