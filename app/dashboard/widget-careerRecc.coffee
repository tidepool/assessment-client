
define [
  'backbone'
  'Handlebars'
  'text!./widget-careerRecc.hbs'
  'core'
], (
  Backbone
  Handlebars
  tmpl
  app
) ->

  _widgetSel = '.widget'
  _className = 'careerRecc'

  View = Backbone.View.extend
    className: "holder doubleWide coolTones #{_className}"
    tagName: 'section'

    initialize: ->

    render: ->
      @$el.html tmpl
      @


  View


