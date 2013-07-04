
define [
  'backbone'
  'Handlebars'
], (
  Backbone
  Handlebars
) ->

  _me = 'game/results/base'
  _className = 'result'

  Handlebars.registerHelper 'prettyDate', (dateStr) ->
    date = new Date dateStr
    return date.toLocaleDateString()
  Handlebars.registerHelper 'prettyTime', (dateStr) ->
    date = new Date dateStr
    return date.toLocaleTimeString()


  View = Backbone.View.extend
    className: _className

    initialize: ->
      @$el.addClass _className # if someone overrode the backbone default, we still need to add this component's classes

    render: ->
      return this unless @model?
      @$el.html @tmpl @model.attributes
      return this



  View


