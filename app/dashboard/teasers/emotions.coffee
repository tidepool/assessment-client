define [
  'backbone'
  'Handlebars'
  'text!./emotions.hbs'
  'dashboard/widgets/base'
], (
  Backbone
  Handlebars
  tmpl
  Widget
) ->

  Widget.extend
    tmpl: tmpl
    className: 'emotions'

