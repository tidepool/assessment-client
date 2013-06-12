define [
  'jquery'
  'backbone'
  'models/result'
],
(
  $
  Backbone
  Result
) ->

  _me = 'models/assessment'

  Assessment = Backbone.Model.extend

    # ------------------------------------------------------------- Backbone Methods
    urlRoot: -> "#{window.apiServerUrl}/api/v1/users/-/games"

    initialize:  ->
      #@on 'all', (e) -> console.log "#{_me} event: #{e}"
      @

    # Server -> Front End. Translates data we receive from the server
    parse: (resp) ->
      # Mix in a result model
      resp.result = new Result resp.result, {parse:true}
      resp


    # addUser: (user) ->
    #   attrs = { 'user_id': user.get('id') }
    #   deferred = $.Deferred()
    #   @save attrs,
    #     patch: false
    #     # url: "#{@url()}/#{@get('id')}"
    #   .done (data, textStatus, jqXHR) ->
    #     console.log("Add User Success: #{textStatus}")
    #     deferred.resolve(jqXHR.response)
    #   .fail (jqXHR, textStatus, errorThrown) ->
    #     console.log("Add User Error: #{textStatus}")
    #     deferred.reject(textStatus)

    #   deferred.promise()

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


    # ------------------------------------------------------------- Public API
    create: (gameId) ->
      @save( definition_id: gameId )
      @

    nextStage: ->
      #console.log "#{_me}.nextStage()"
      i = @get('stage_completed')
      @save( stage_completed: i + 1 )




  Assessment