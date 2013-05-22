define [
  'Backbone'
  'Handlebars'
  'text!./about.hbs'
], (
  Backbone
  Handlebars
  tmpl
) ->
  Me = Backbone.View.extend
    className: 'aboutPage'
    initialize: ->
    render: ->
      @$el.html tmpl
      @
  Me

