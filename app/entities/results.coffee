

define [
  'jquery'
  'backbone'
], (
  $
  Backbone
) ->



  Model = Backbone.Model.extend
    urlRoot: ->
      gameId = @get('game_id')
      "#{window.apiServerUrl}/api/v1/users/-/games/#{gameId}/result"

    initialize: ->
      @calculateResult()




    calculateResult: ->
      deferred = $.Deferred()
      @startCalculation()
      .done =>
        @checkForProgress(true, null)
        .done =>
          @fetch()
          .done (data, textStatus, jqXHR) =>
            deferred.resolve()
          .fail (jqXHR, textStatus, errorThrown) =>
            deferred.reject()
        .fail =>
          deferred.reject()
      .fail =>
        deferred.reject()
      deferred.promise()

    startCalculation: ->
      deferred = $.Deferred()
      @timeoutAttempt = 0
      attrs = {}
      @save(attrs)       
      .done (data, textStatus, jqXHR) =>
        console.log("Unexpected StatusCode: #{jqXHR.status}") if jqXHR.status isnt 202
        @progressLink = data.status.link
        deferred.resolve(jqXHR.response)
      .fail (jqXHR, textStatus, errorThrown) ->
        console.log("Start Calculation Error: #{textStatus}")
        deferred.reject(textStatus)

      deferred.promise()
    
    checkForProgress: (firstTime, deferred) ->
      if (firstTime) 
        # Make sure we don't have nested deferred's
        # This is called on a timer
        deferred = $.Deferred()
      if @progressLink?
        $.ajax
          type: 'GET'
          url: @progressLink
        .done (data, textStatus, jqXHR) =>
          console.log("Unexpected StatusCode: #{jqXHR.status}") if jqXHR.status isnt 200
          switch data.status.state
            when 'pending'
              @progressLink = data.status.link
              # continue pinging every 1s
              @timeoutAttempt += 1 
              if @timeoutAttempt is 4
                deferred.reject 'Timed out waiting for results.'
              else
                setTimeout =>
                  @checkForProgress(false, deferred)
                , 500
            when 'done'
              console.log("Done with results")
              @set 'status', data.status
              deferred.resolve(jqXHR.response)
            when 'error'
              deferred.reject(textStatus)
            else
              console.log("Unexpected status #{data.status.state}")
              deferred.reject(textStatus)
        .fail (jqXHR, textStatus, errorThrown) ->
          deferred.reject(textStatus)
      else
        deferred.reject("No url to check for progress")

      if (firstTime)
        deferred.promise()



      # ----------------------------------------------------------------------------------- Public API


  Model
