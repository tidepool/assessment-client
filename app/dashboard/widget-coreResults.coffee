
define [
  'backbone'
  'Handlebars'
  'text!./widget-coreResults.hbs'
  'composite_views/perch'
  'markdown'
  'core'
  'ui_widgets/share'
], (
  Backbone
  Handlebars
  tmpl
  perch
  markdown
  app
  ShareView
) ->

  _widgetSel = '.widget'
  _className = 'coreResults '

  View = Backbone.View.extend
    tmpl: Handlebars.compile tmpl
    className: "holder doubleWide tall #{_className}"
    tagName: 'section'
    events:
      'click .widget': 'onClick'

    initialize: ->
      @listenTo @model, 'change', @render

    render: ->
      @$el.html @tmpl @model.attributes
      share = new ShareView data:
        title: "My personality is '#{@model.attributes.name}'"
        text: 'You can find out your personality, too, at https://alpha.tidepool.co'
        link: 'https://alpha.tidepool.co'
        image: "https://alpha.tidepool.co/images/badges/#{@model.attributes.logo_url}"
      @$el.append share.render().el
      @

    onClick: ->
      descHtml = markdown.toHTML @model.attributes.description
      perch.show
        large: true
        title: @model.attributes.name
        msg: descHtml
        btn1Text: 'Ok'
      app.analytics.track _className, 'Detailed Core Personality Results Viewed'




  View


