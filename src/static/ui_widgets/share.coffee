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
      'click .action-facebook': 'onClickFacebook'
      'click .action-twitter': 'onClickTwitter'
      'click .action-email': 'onClickMailto'

    render: ->
      @$el.html tmpl
      return this


    # ---------------------------------------------------------------- Event Handlers
    onClickFacebook: (e) ->
      e.stopPropagation()
      facebookShareBear = new Facebook
        picture: @options.data.image
        link: @options.data.link
        name: @options.data.title
        caption: @options.data.text
      facebookShareBear.save()
      app.analytics.trackKeyMetric @className, 'clicked facebook'

    onClickTwitter: (e) ->
      e.stopPropagation()
      twitterShareBear = new Twitter
        text: "#{@options.data.title} -- "
        url: @options.data.link
      twitterShareBear.save()
      app.analytics.trackKeyMetric @className, 'clicked twitter'

    onClickMailto: (e) ->
      e.stopPropagation()
      email = new Email
        subject: @options.data.title
        body: @options.data.text
      email.save()
      app.analytics.trackKeyMetric @className, 'clicked mailto'


    # ---------------------------------------------------------------- Public API




  Me