
define [
  'backbone'
  'Handlebars'
  'text!./widget-coreResults.hbs'
  'composite_views/perch'
  'markdown'
  'core'
], (
  Backbone
  Handlebars
  tmpl
  perch
  markdown
  app
) ->

  _widgetSel = '.widget'
  _className = 'coreResults '

  View = Backbone.View.extend
    tmpl: Handlebars.compile tmpl
    className: "holder doubleWide tall #{_className}"
    tagName: 'section'
    events:
      click: 'onClick'
    initialize: ->
      @listenTo @model, 'change', @render

    render: ->
      @$el.html @tmpl @model.attributes
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


