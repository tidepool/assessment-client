
define [
  'backbone'
  'Handlebars'
  'text!./loading.hbs'
  'text!./base.hbs'
], (
  Backbone
  Handlebars
  tmplLoading
  tmplBase
) ->

  _me = 'dashboard/widget'
  _className = 'holder'

  View = Backbone.View.extend
    className: _className
    tagName: 'section'
    tmplBase: Handlebars.compile tmplBase

    initialize: ->
      # If there's a model, we should render once it syncs. Otherwise, render right away
      if @model
        @renderLoading()
        @listenTo @model, 'sync', @render
      else
        @render()
      @$el.addClass _className # if someone overrode the backbone default, we still need to add this component's classes

    # ---------------------------------------------------------------------------- Public API
    renderLoading: ->
      @$el.html tmplLoading
      @




  View


