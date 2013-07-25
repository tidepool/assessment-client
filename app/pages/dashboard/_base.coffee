define [
  'backbone'
  'core'
  'dashboard/widgetmaster'
], (
  Backbone
  app
  Widgetmaster
) ->

  View = Backbone.View.extend
    title: null
    className: null

    initialize: ->
      @listenTo app.user, 'sync', @render
      app.trigger 'session:showLogin' unless app.user.isLoggedIn()

    renderWidgets: (widgetList) ->
      @widgetmaster = new Widgetmaster widgets: widgetList
      @$el.html @widgetmaster.render().el
      @

  View

