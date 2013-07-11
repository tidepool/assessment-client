
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
    title: 'Dashboard'
    className: 'dashboard-all'

    initialize: ->
      @listenTo app.user, 'sync', @render
      app.trigger 'session:showLogin' unless app.user.isLoggedIn()

    render: ->
      @widgetmaster = new Widgetmaster
        widgets: [
          'dashboard/personality/core'
          'dashboard/personality/big5'
          'dashboard/personality/detailed_report'
          'dashboard/personality/holland6'
          'dashboard/personality/recommendation'
          'dashboard/career/jobs'
          'dashboard/teasers/reaction_time'
          'dashboard/teasers/emotions'
          'dashboard/career/skills'
          'dashboard/career/tools'
          'dashboard/emotions/historical_highest'
          'dashboard/emotions/highest_emotion'
          'dashboard/emotions/strongest_emotions'
        ]
      @$el.html @widgetmaster.render().el
      return this


#        model: new Backbone.Model @model.attributes.big5_score
#        model: new Backbone.Model @model.attributes.holland6_score



    # ---------------------------------------------------------------- Private


    # ---------------------------------------------------------------- Event Callbacks

  View

