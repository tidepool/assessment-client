define [
  'Backbone'
  'Handlebars'
  "text!./investors.hbs"
], (
  Backbone
  Handlebars
  tmpl
) ->
  Me = Backbone.View.extend
    className: 'investorsPage'
    render: ->
      @$el.html tmpl
      @
  Me