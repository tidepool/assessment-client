
define [
  'backbone'
  'Handlebars'
  'text!./widget-coreResults.hbs'
  'composite_views/perch'
], (
  Backbone
  Handlebars
  tmpl
  perch
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
      fullDescription = @model.attributes.description.join '<br/><br/>'
      perch.show
        large: true
        title: @model.attributes.name
        msg: fullDescription
        btn1Text: 'Ok'

  View


