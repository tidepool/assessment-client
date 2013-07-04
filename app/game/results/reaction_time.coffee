define [
  'backbone'
  'Handlebars'
  'game/results/base'
  'text!./reaction_time.hbs'
], (
  Backbone
  Handlebars
  ResultView
  tmpl
) ->

  View = ResultView.extend
    className: 'reactionTime'
    tmpl: Handlebars.compile tmpl

  View
