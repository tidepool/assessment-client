
define [
  'backbone'
  'Handlebars'
  'text!./widget-dailyRecc.hbs'
  'text!./widget-dailyReccDetails.hbs'
  'entities/recommendations'
  'composite_views/perch'
  'core'
], (
  Backbone
  Handlebars
  tmpl
  tmplDetails
  Recommedations
  perch
  app
) ->

  _widgetSel = '.widget'

  View = Backbone.View.extend
    tmplDetails: Handlebars.compile tmplDetails
    className: 'holder dailyRecc'
    tagName: 'section'
    events:
      click: 'onClick'
    initialize: ->
      @model = new Recommedations()
      @listenTo @model, 'sync', @render
      @model.latest()

    render: ->
      @$el.html tmpl
      @_detailsMarkup = @tmplDetails @model.attributes
      @

    onClick: ->
      return unless @_detailsMarkup
      perch.show
        content: @_detailsMarkup
        btn1Text: null
        supressTracking: true
        large: true
      #TODO: track

  View


