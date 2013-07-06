define [
  'backbone'
  'Handlebars'
  "text!./team.hbs"
], (
  Backbone
  Handlebars
  tmpl
) ->
  Me = Backbone.View.extend
    title: 'Our Team'
    className: 'teamPage'
    render: ->
      @$el.html tmpl
      @
  Me