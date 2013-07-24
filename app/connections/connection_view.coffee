

define [
  'backbone'
  'Handlebars'
  'text!./connection_view.hbs'
],
(
  Backbone
  Handlebars
  tmpl
) ->

  _tmpl = Handlebars.compile tmpl

  View = Backbone.View.extend
    className: 'connection'
    tagName: 'li'

    # ----------------------------------------------------------- Backbone Methods
    initialize: ->

    render: ->
      @$el.html _tmpl @model.attributes
      @


  View
