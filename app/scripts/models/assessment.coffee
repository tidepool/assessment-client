define [
  'jquery',
  'Backbone',
  'models/result', 
  'models/user'], ($, Backbone, Result) ->  
  Assessment = Backbone.Model.extend
    urlRoot: ->
      "#{window.apiServerUrl}/api/v1/assessments"

    initialize:  ->
      # @url = window.apiServerUrl + @urlRoot

    create: (definitionId) ->
      deferred = $.Deferred()
      @save({'def_id': definitionId })
      .done (data, textStatus, jqXHR) ->
        console.log('Assessment created successfully')
        deferred.resolve(jqXHR.response)
      .fail (jqXHR, textStatus, errorThrown) ->
        console.log('Cannot create an assessment.')
        deferred.reject(textStatus)
      deferred.promise()

    updateProgress: (stageCompleted) ->
      # Rails 4 is going to introduce support for the PATCH verb in HTTP
      # TODO: Switch to PATCH when Rails 4 switch happens
      attrs = { 'stage_completed': stageCompleted }
      deferred = $.Deferred()
      @save attrs,
        patch: false
        # url: "#{@url()}/#{@get('id')}"
      .done (data, textStatus, jqXHR) =>
        console.log("Update Progress Success: #{textStatus}")
        @trigger('stage_completed_success')
        deferred.resolve(jqXHR.response)
      .fail (jqXHR, textStatus, errorThrown) ->
        console.log("Update Progress Error: #{textStatus}")
        deferred.reject(textStatus)

      deferred.promise()

    addUser: (user) ->
      attrs = { 'user_id': user.get('id') }
      deferred = $.Deferred()
      @save attrs,
        patch: false
        # url: "#{@url()}/#{@get('id')}"
      .done (data, textStatus, jqXHR) ->
        console.log("Add User Success: #{textStatus}")
        deferred.resolve(jqXHR.response)
      .fail (jqXHR, textStatus, errorThrown) ->
        console.log("Add User Error: #{textStatus}")
        deferred.reject(textStatus)

      deferred.promise()

    getResult: ->
      deferred = $.Deferred()

      if @result?
        deferred.resolve("Result already exists")
      else
        @result = new Result(@get('id'))
        if @get('status') is 'results_ready'
          @result.getResult()
          .done =>
            deferred.resolve()
          .fail =>
            deferred.reject()
        else
          @result.calculateResult()
          .done =>
            deferred.resolve()
          .fail =>
            deferred.reject()
 
      deferred.promise()

  Assessment