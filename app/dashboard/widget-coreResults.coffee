
define [
  'backbone'
  'Handlebars'
  'text!./widget-coreResults.hbs'
  'composite_views/perch'
  'markdown'
], (
  Backbone
  Handlebars
  tmpl
  perch
  markdown
) ->

  _widgetSel = '.widget'

  View = Backbone.View.extend
    tmpl: Handlebars.compile tmpl
    className: 'holder coreResults doubleWide tall'
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

  View


