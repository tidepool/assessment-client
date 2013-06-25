
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
      @listenTo app, 'session:logOut', @onLogOut
      app.trigger 'session:showLogin' unless app.user.isLoggedIn()

    render: ->
      @widgetmaster = new Widgetmaster
        widgets: [
          'dashboard/career/jobs'
          'dashboard/career/skills'
          'dashboard/career/tools'
        ]
      @$el.html @widgetmaster.render().el
      return this


    # ---------------------------------------------------------------- Event Callbacks
    onLogOut: -> app.router.navigate 'home', trigger:true


  View

