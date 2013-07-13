define [
  'backbone'
  'Handlebars'
  'text!./personalizations.hbs'
  'dashboard/widgets/base'
  'core'
], (
  Backbone
  Handlebars
  tmpl
  Widget
  app
) ->

  Widget.extend
    tmpl: tmpl
    className: 'twilight doubleWide'
    events: click: 'onClick'
    onClick: -> app.trigger 'action:showPersonalizations'

