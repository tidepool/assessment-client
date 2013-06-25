
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

  Handlebars.registerHelper 'commaList', (array) ->
    prettyList = ''
    prettyList += "#{item}, " for item in array
    return prettyList.slice(0, -2)
  _tmpl = Handlebars.compile tmpl

  View = Backbone.View.extend
    className: "holder doubleWide coolTones #{_className}"
    tagName: 'section'

    initialize: ->

    render: ->
      @$el.html _tmpl @model.attributes
      @


  View


