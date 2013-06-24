
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
  _className = 'personalityReport'

  View = Backbone.View.extend
    className: "holder #{_className}"
    tagName: 'section'
    events:
      'click .widget': 'onClick'
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
        icon: 'icon-ok'
      app.analytics.track _className, 'Teaser Pressed'
      $.ajax
        url: "#{window.apiServerUrl}/api/v1/users/-/preorders"
        type: 'POST'
      .done (data, textStatus, jqXHR) =>
        console.log("sent message to preorders")
      .fail (jqXHR, textStatus, errorThrown) =>
        console.log("failed to send the preorder")

  View


