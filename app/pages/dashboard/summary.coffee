
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
    title: 'Summary Dashboard'
    className: 'dashboard-summary'

    initialize: ->
      @listenTo app.user, 'sync', @render
      app.trigger 'session:showLogin' unless app.user.isLoggedIn()

    render: ->
      @widgetmaster = new Widgetmaster
        widgets: [
          'dashboard/personality/core'
          'dashboard/teasers/personalizations'
          'dashboard/career/reaction_history'
          'dashboard/emotions/historical_highest'
          'dashboard/personality/big5'
          'dashboard/personality/holland6'
          'dashboard/teasers/reaction_time'
          'dashboard/personality/detailed_report'
        ]
      @$el.html @widgetmaster.render().el
      @

  View

