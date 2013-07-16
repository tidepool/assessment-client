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

  View = Widget.extend
    tmpl: tmpl
    className: 'twilight doubleWide'
    events: click: 'onClick'

    # Overriding default behavior here. Most widgets need data to display.
    # In this case it's the opposite--the widget should only show up if the user hasn't put in data yet.
    onSync: () ->
#      console.log model:@model
      if @model and not @model.attributes.data
        @render()
      else
        @remove()

    onClick: ->
      app.analytics.track 'Personalizations', 'Teaser Pressed'
      app.trigger 'action:showPersonalizations'


  View.dependsOn = 'entities/preferences/training'
  View


