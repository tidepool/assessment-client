
define [
  'backbone'
  'Handlebars'
  'core'
  'dashboard/widgetmaster'
], (
  Backbone
  Handlebars
  app
  Widgetmaster
) ->

  View = Backbone.View.extend
    title: 'Mood Dashboard'
    className: 'dashboard-mood'

    initialize: ->
      @listenTo app.user, 'sync', @render
      app.trigger 'session:showLogin' unless app.user.isLoggedIn()

    render: ->
      @widgetmaster = new Widgetmaster
        widgets: [
          'dashboard/emotions/highest_emotion'
          'dashboard/emotions/historical_highest'
          'dashboard/emotions/strongest_emotions'
          'dashboard/teasers/reaction_time'
        ]
      @$el.html @widgetmaster.render().el
      @

  View

