
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

    className: 'dashboard-career'

    initialize: ->
      @listenTo app.user, 'sync', @render
      app.trigger 'session:showLogin' unless app.user.isLoggedIn()

    render: ->
      @widgetmaster = new Widgetmaster
        widgets: [
          'dashboard/career/jobs'
          'dashboard/career/skills'
          'dashboard/career/tools'
          'dashboard/career/reaction_results'
          'dashboard/career/reaction_history'
        ]
      @$el.html @widgetmaster.render().el
      return this


  View

