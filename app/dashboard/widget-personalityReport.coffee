
define [
  'backbone'
  'Handlebars'
  'text!./widget-personalityReport.hbs'
  'composite_views/perch-psst'
  'core'
], (
  Backbone
  Handlebars
  tmpl
  perchPsst
  app
) ->

  _widgetSel = '.widget'

  View = Backbone.View.extend
    className: 'holder personlityReport'
    tagName: 'section'
    events:
      click: 'onClick'
    initialize: ->

    render: ->
      @$el.html tmpl
      @

    onClick: ->
      if app.user.attributes.email
        msg = "Thanks for your interest, we'll notify you at <strong>#{app.user.attributes.email}</strong> when your report is available"
      else
        msg = "Thanks for your interest, we'll notify you when your report is available"

      perchPsst.show
        msg: msg
        icon: 'icon-check'
        btn1Text: null

  View


