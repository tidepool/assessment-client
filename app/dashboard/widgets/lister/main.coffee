
define [
  'backbone'
  'Handlebars'
  'text!./lister.hbs'
  'dashboard/widgets/base'
], (
  Backbone
  Handlebars
  tmpl
  Widget
) ->

  _className = 'holder lister'
  _tmpl = Handlebars.compile tmpl

  View = Widget.extend
    className: _className
    tagName: 'section'

    initialize: ->
      @renderLoading()
      @listenTo @model, 'sync', @render
      @$el.addClass _className # if someone overrode the backbone default, we still need to add this component's classes

    renderList: (data) ->
      console.error "Need data.list and data.title" unless data.list and data.title
      @$el.html _tmpl data
      return this

  View





