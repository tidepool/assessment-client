
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
      @listenTo app, 'session:logOut', @onLogOut
      app.trigger 'session:showLogin' unless app.user.isLoggedIn()

    render: ->
      @widgetmaster = new Widgetmaster
        widgets: [
          'dashboard/personality/core'
          'dashboard/personality/big5'
          'dashboard/personality/detailed_report'
          'dashboard/personality/holland6'
          'dashboard/personality/recommmendation'
          'dashboard/career/jobs'
          'dashboard/career/skills'
          'dashboard/career/tools'
        ]
      @$el.html @widgetmaster.render().el
      return this


    # ---------------------------------------------------------------- Private


    # ---------------------------------------------------------------- Event Callbacks
    onLogOut: -> app.router.navigate 'home', trigger:true


  View

