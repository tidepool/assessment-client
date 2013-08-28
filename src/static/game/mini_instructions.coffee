define [
  'backbone'
], (
  Backbone
) ->

  View = Backbone.View.extend
    className: 'miniInstructions'

    initialize: ->
      @model = new Backbone.Model
      @listenTo @model, 'change', @render

    render: ->
      @$el.html @model.attributes.text
      @

  View

