

define [
  'backbone'
  'Handlebars'
  'text!./connection.hbs'
  'entities/auth_link'
],
(
  Backbone
  Handlebars
  tmpl
  AuthLink
) ->

  _tmpl = Handlebars.compile tmpl

  View = Backbone.View.extend
    className: 'connection'
    tagName: 'li'

    # ----------------------------------------------------------- Backbone Methods
    initialize: ->
      @model = new AuthLink user_id: @options.app.user.id

    render: ->
      @$el.html _tmpl @model.attributes
      @


  View
