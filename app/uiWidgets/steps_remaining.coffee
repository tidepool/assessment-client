

define [
  'jquery'
  'Backbone'
  'Handlebars'
  "text!./steps_remaining.hbs"
],
(
  $
  Backbone
  Handlebars
  tmpl
) ->

  View = Backbone.View.extend
    className: 'stepsRemaining'
    initialize: ->
      throw new Error 'Need a collection to build a stepsRemaining view' unless @collection
      @tmpl = Handlebars.compile(tmpl)
      @listenTo @collection, 'change', @_onChange

    render: ->
      @$el.html @tmpl
        steps: @collection.toJSON()
      @

    _onChange: ->
      console.log 'Steps remaining change event fired'
      @render()


  View


