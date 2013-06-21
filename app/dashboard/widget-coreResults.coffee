
define [
  'backbone'
  'Handlebars'
  'text!./widget-coreResults.hbs'
  'composite_views/perch'
  'markdown'
  'core'
  'entities/careBears/facebook'
  'entities/careBears/twitter'
], (
  Backbone
  Handlebars
  tmpl
  perch
  markdown
  app
  Facebook
  Twitter
) ->

  _widgetSel = '.widget'
  _className = 'coreResults '

  View = Backbone.View.extend
    tmpl: Handlebars.compile tmpl
    className: "holder doubleWide tall #{_className}"
    tagName: 'section'
    events:
      click: 'onClick'
      'click #ActionShareFacebook-Personality': 'onClickFacebook'
      'click #ActionShareTwitter-Personality': 'onClickTwitter'

    initialize: ->
      @listenTo @model, 'change', @render

    render: ->
      @$el.html @tmpl @model.attributes
      console.log model: @model.attributes
      @

    onClick: ->
      descHtml = markdown.toHTML @model.attributes.description
      perch.show
        large: true
        title: @model.attributes.name
        msg: descHtml
        btn1Text: 'Ok'
      app.analytics.track _className, 'Detailed Core Personality Results Viewed'

    onClickFacebook: (e) ->
      e.stopPropagation()
      facebookShareBear = new Facebook
        picture: "https://alpha.tidepool.co/images/badges/#{@model.attributes.logo_url}"
        link: 'https://alpha.tidepool.co'
        name: "My personality is '#{@model.attributes.name}'"
        caption: 'Link Caption'
        description: 'Link Description'

      facebookShareBear.save()

    onClickTwitter: (e) ->
      e.stopPropagation()
      twitterShareBear = new Twitter
        text: "My personality is '#{@model.attributes.name}' -- "
        url: 'https://alpha.tidepool.co'
      twitterShareBear.save()




  View


