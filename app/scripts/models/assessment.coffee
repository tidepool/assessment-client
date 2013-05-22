define [
  'jquery'
  'Backbone'
  'models/result'
],
(
  $
  Backbone
  Result
) ->

  _me = 'models/assessment'

  Assessment = Backbone.Model.extend
    urlRoot: ->
      "#{window.apiServerUrl}/api/v1/assessments"

    initialize:  ->
      @on 'all', (eventName) -> console.log "AssessmentModel Event: #{eventName}"
      @

    # Server -> Front End. Translates data we receive from the server
    parse: (resp) ->
      # Mix in a result model
      resp.result = new Result resp.result, {parse:true}
      resp

    create: (definitionId) ->
      deferred = $.Deferred()
      @save({'def_id': definitionId })
        .done (data, textStatus, jqXHR) ->
          console.log("#{_me}.create.save.done()")
          deferred.resolve(jqXHR.response)
        .fail (jqXHR, textStatus, errorThrown) ->
          console.log("#{_me}.create.save.fail()")
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
        deferred.resolve(jqXHR.response)
      .fail (jqXHR, textStatus, errorThrown) ->
        throw new Error "Update Progress Error: #{textStatus}"
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

    getLatestWithProfile: ->
      deferred = $.Deferred()
      @fetch({ url: "#{@url()}/latest_with_profile" })
        .done (data, textStatus, jqXHR) =>
          console.log('Got the latest assessment')
          deferred.resolve()
        .fail (jqXHR, textStatus, errorThrown) =>
            deferred.reject()
      deferred.promise()   

    getResult: ->
      deferred = $.Deferred()

      if @get('result')?
        deferred.resolve("Result already exists")
      else
        result = new Result({assessment_id: @get('id')})
        @set({result: result})
        if @get('status') is 'results_ready'
          result = @get('result')
          result.fetch()
          .done (data, textStatus, jqXHR) =>
            console.log("Get Result Success: #{textStatus}") 
            deferred.resolve(jqXHR.response)
          .fail (jqXHR, textStatus, errorThrown) =>
            console.log("Get Result Error: #{textStatus}")
            deferred.reject(textStatus)
        else
          result = @get('result')
          result.calculateResult()
          .done =>
            deferred.resolve()
          .fail =>
            deferred.reject()
 
      deferred.promise()

  Assessment