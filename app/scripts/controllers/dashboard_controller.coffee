define [
  'jquery'
  'Backbone'
  'dashboard/dashboard_main_view'
  'models/assessment'
], (
  $
  Backbone
  DashboardMainView
  Assessment
) ->
  DashboardController = ->
    initialize: (options) ->
      _.extend(@, Backbone.Events)
      @session = options.session

    render: ->
      @fetchData()
      .done =>
        view = new DashboardMainView({assessment: @session.assessment})
        $('#content').html(view.render().el)
      .fail =>

    fetchData: ->
      deferred = $.Deferred()
      @session.getUserInfo()
      .done =>
        # Get the last assesment
        @session.assessment = new Assessment()
        @session.assessment.getLatestWithProfile()
        .done (data, textStatus, jqXHR) =>
          console.log('Got the latest assessment')
          deferred.resolve()
        .fail (jqXHR, textStatus, errorThrown) =>
          deferred.reject()
      .fail =>
        deferred.reject("Cannot get the users")

      deferred.promise()

  DashboardController