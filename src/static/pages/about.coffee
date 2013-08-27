define [
  'backbone'
  'Handlebars'
  'text!./about.hbs'
], (
  Backbone
  Handlebars
  tmpl
) ->

  Me = Backbone.View.extend
    title: 'About Us'
    className: 'aboutPage'
    initialize: ->
    render: ->
      @$el.html tmpl
      @

  Me

