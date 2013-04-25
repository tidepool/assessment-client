define [
  'jquery',
  'Backbone',
  'dashboard/dashboard_main_view',
  'models/assessment',
  'models/stage',
  'controllers/session_controller'], ($, Backbone, DashboardMainView, Assessment) ->
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
        if @session.assessment?
          @ensureUser()
          .done =>
            # Ensure we have the results 
            @session.assessment.getResult()
            .done =>
              deferred.resolve()
            .fail => 
              deferred.reject()
          .fail =>
            deferred.reject()
        else 
          # Get the last assesment
          assessment = new Assessment()
          assessment.fetch({id: 'latest'})
          .done =>
            @session.assessment = assesment
            deferred.resolve()
          .fail =>
            deferred.reject()
      .fail =>
        deferred.reject("Cannot get the users")

      deferred.promise()

    ensureUser: ->
      deferred = $.Deferred()
      if @session.transferOwnerFlag is true 
        # There was a guest user before
        # We need to transfer the existing assessment in memory to the logged in user
        @session.assessment.addUser(@session.user)
        .done =>
          deferred.resolve()
        .fail =>
          deferred.reject()
      else 
        deferred.resolve()

      deferred.promise()

  DashboardController