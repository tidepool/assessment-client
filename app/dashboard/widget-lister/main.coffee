
define [
  'backbone'
  'Handlebars'
  'text!./main.hbs'
], (
  Backbone
  Handlebars
  tmpl
) ->

  _widgetSel = '.widget'
  _className = 'holder lister'
  _tmpl = Handlebars.compile tmpl

  View = Backbone.View.extend
    className: _className
    tagName: 'section'

    initialize: ->


    render: ->
      @$el.html _tmpl @options
      @$el.addClass _className if @options.className? # if someone overrode the backbone default, we still need to add this component's classes
      @


  View





