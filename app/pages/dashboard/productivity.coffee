
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
    title: 'Productivity Dashboard'
    className: 'dashboard-productivity'

    initialize: ->
      @listenTo app.user, 'sync', @render
      app.trigger 'session:showLogin' unless app.user.isLoggedIn()

    render: ->
      @widgetmaster = new Widgetmaster
        widgets: [
          'dashboard/career/reaction_history'
          'dashboard/career/reaction_results'
          'dashboard/teasers/emotions'
          'dashboard/career/jobs'
          'dashboard/career/skills'
          'dashboard/career/tools'
          'dashboard/teasers/snoozer'
        ]
      @$el.html @widgetmaster.render().el
      @


  View

