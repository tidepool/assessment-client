
define [
  'backbone'
  'Handlebars'
  'text!./loading.hbs'
], (
  Backbone
  Handlebars
  tmplLoading
) ->

  _me = 'dashboard/widget'
  _className = 'holder'

  View = Backbone.View.extend
    className: _className
    tagName: 'section'

    initialize: ->
      @renderLoading()
      @listenTo @model, 'sync', @render
      @$el.addClass _className # if someone overrode the backbone default, we still need to add this component's classes

    # ---------------------------------------------------------------------------- Public API
    renderLoading: ->
      @$el.html tmplLoading
      @




  View


