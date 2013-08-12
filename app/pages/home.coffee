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
    title: 'Home'
    className: 'homePage'
    tmpl: Handlebars.compile tmpl
    render: ->
      @$el.html @tmpl()
      @layout?.shimmerLogo?()
      @
  Me

