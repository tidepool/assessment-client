define [
  'backbone'
  'Handlebars'
  'text!./personality.hbs'
], (
  Backbone
  Handlebars
  tmpl
) ->

  View = Backbone.View.extend
    className: 'dashboardPage'
    initialize: ->
    render: ->
      @$el.html tmpl
      @

  View

