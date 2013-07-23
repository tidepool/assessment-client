define [
  'backbone'
  'Handlebars'
  'text!./reaction_time.hbs'
  'dashboard/widgets/base'
], (
  Backbone
  Handlebars
  tmpl
  Widget
) ->

  Widget.extend
    tmpl: tmpl
    className: 'teaser-reactionTime'

