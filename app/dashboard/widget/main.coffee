
define [
  'backbone'
  'Handlebars'
  'text!./main.hbs'
], (
  Backbone
  Handlebars
  tmpl
) ->

  _me = 'dashboard/widget'

  View = Backbone.View.extend
    tmpl: Handlebars.compile tmpl
    className: 'holder'
    tagName: 'section'
    initialize: ->
    render: ->
      @$el.html tmpl
      @


    # ---------------------------------------------------------------------------- Private

  View


