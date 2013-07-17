

define [
  'backbone'
  'Handlebars'
  'text!./connection.hbs'
  'entities/connection'
],
(
  Backbone
  Handlebars
  tmpl
  Connection
) ->

  _tmpl = Handlebars.compile tmpl

  View = Backbone.View.extend
    className: 'connection'
    tagName: 'li'

    # ----------------------------------------------------------- Backbone Methods
    initialize: ->
      @model = new Connection user_id: @options.app.user.id

    render: ->
      @$el.html _tmpl @model.attributes
      @


  View
