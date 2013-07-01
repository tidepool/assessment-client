
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

    className: 'dashboard-all'

    initialize: ->
      @listenTo app.user, 'sync', @render
      app.trigger 'session:showLogin' unless app.user.isLoggedIn()

    render: ->
      @widgetmaster = new Widgetmaster
        widgets: [
          'dashboard/personality/core'
          'dashboard/personality/big5'
#          'dashboard/teasers/reaction_time'
          'dashboard/personality/recommendation'
          'dashboard/personality/holland6'
          'dashboard/personality/detailed_report'
          'dashboard/career/jobs'
          'dashboard/career/skills'
          'dashboard/career/tools'
        ]
      @$el.html @widgetmaster.render().el
      return this


#        model: new Backbone.Model @model.attributes.big5_score
#        model: new Backbone.Model @model.attributes.holland6_score



    # ---------------------------------------------------------------- Private


    # ---------------------------------------------------------------- Event Callbacks

  View

