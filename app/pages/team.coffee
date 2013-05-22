define [
  'Backbone'
  'Handlebars'
  "text!./team.hbs"
], (
  Backbone
  Handlebars
  tmpl
) ->
  Me = Backbone.View.extend
    className: 'teamPage'
    render: ->
      @$el.html tmpl
      @
  Me