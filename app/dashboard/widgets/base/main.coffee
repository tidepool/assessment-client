
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
        @listenTo @model, 'sync', @onSync
        @listenTo @model, 'error', @onErr
      else if @collection
        @renderLoading()
        @listenTo @collection, 'sync', @onSync
        @listenTo @collection, 'error', @onErr
      else
        @render()
      @$el.addClass _className # if someone overrode the backbone default, we still need to add this component's classes
      @start?()

    render: ->
      if @tmpl
        @$el.html @tmpl
      else
        @$el.html tmplBase
      return this

    onSync: ->
      if @collection and @collection.length is 0
#        console.log "#{_me} Server returned empty collection, hiding the widget"
        @close?()
        @remove()
      else if @model and _.isEmpty @model.attributes
#        console.log "#{_me} Server returned empty collection, hiding the widget"
        @close?()
        @remove()
      else
        @render()

    onErr: ->
      console.warn "#{_me} Error with the widget's model, hiding the widget."
      @remove()


    # ---------------------------------------------------------------------------- Public API
    renderLoading: ->
      @$el.html tmplLoading
      @





  View


