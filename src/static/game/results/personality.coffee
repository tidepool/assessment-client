define [
  'backbone'
  'Handlebars'
  'game/results/base'
  'text!./personality.hbs'
  'markdown'
], (
  Backbone
  Handlebars
  ResultView
  tmpl
  markdown
) ->

  _me = 'game/results/personality'

  View = ResultView.extend
    className: 'personality'
    tmpl: Handlebars.compile tmpl
    start: ->
#      console.log "#{_me}.start()"
#      console.log model:@model.attributes
      @_prepareData()

    _prepareData: ->
      attrs = @model.attributes
      attrs.one_liner = markdown.toHTML attrs.one_liner
      @model.set attrs
      return this

  View
