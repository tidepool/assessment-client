define [
  'backbone'
  'Handlebars'
  'text!./home.hbs'
], (
  Backbone
  Handlebars
  tmpl
) ->
  Me = Backbone.View.extend
    className: 'homePage'
    tmpl: Handlebars.compile tmpl
    render: ->
      @$el.html @tmpl()
      @
  Me

