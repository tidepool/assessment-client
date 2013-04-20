define [
  'jquery',
  'Backbone',
  'dashboard/dashboard_main_view',
  'models/stage',
  'models/assessment',
  'controllers/session_controller'], ($, Backbone, DashboardMainView) ->
  DashboardController = ->
    initialize: (options) ->
      _.extend(@, Backbone.Events)
      @session = options.session

      # TODO: Get result and assessment if they don't exist in memory yet

    render: ->
      view = new DashboardMainView({model: @session.result, assessment: @session.assessment})
      $('#content').html(view.render().el)


  DashboardController