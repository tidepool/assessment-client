define [
  'jquery',
  'Backbone'], ($, Backbone) ->  
  Result = Backbone.Model.extend
    initialize: (assessment_id) ->
      @url = "#{window.apiServerUrl}/api/v1/assessments/#{assessment_id}/results"

    calculateResult: ->
      deferred = $.Deferred()
      @startCalculation()
      .then =>
        @checkForProgress(true, null)
      .then =>
        @getResults()
      .then =>
        deferred.resolve()

      deferred.promise()

    startCalculation: ->
      deferred = $.Deferred()
      attrs = {}
      @save(attrs)       
      .done (data, textStatus, jqXHR) =>
        console.log("Start Calculation Success: #{textStatus}") 
        statusCode = jqXHR.statusCode()
        if statusCode isnt 202
          # We were expecting 202 (accepted) as status code
          console.log("Unexpected StatusCode #{statusCode}")
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
          console.log("Check For Progress Success: #{textStatus}")
          statusCode = jqXHR.statusCode()
          if statusCode isnt 200
            # We were expecting 200 (ok) as status code
            console.log("Unexpected StatusCode #{statusCode}")
          switch data.status.state
            when 'pending'
              @progressLink = data.status.link
              console.log("Still pending for results")
              # continue pinging every 1s
              setTimeout => 
                @checkForProgress(false, deferred)
              , 1000
            when 'done'
              console.log("Done with results")
              deferred.resolve(jqXHR.response)
            when 'error'
              console.log("Server error, no results")
              deferred.reject(textStatus)
            else
              console.log("Unexpected status #{data.status.state}")
              deferred.reject(textStatus)
        .fail (jqXHR, textStatus, errorThrown) ->
          console.log("Check For Progress Error: #{textStatus}")
          deferred.reject(textStatus)
      else
        console.log("No url to check for progress")
        deferred.reject("No url to check for progress")

      if (firstTime)
        deferred.promise()

    getResults: ->
      deferred = $.Deferred()
      @fetch()
      .done (data, textStatus, jqXHR) =>
        console.log("Get Results Success: #{textStatus}") 
        deferred.resolve(jqXHR.response)
      .fail (jqXHR, textStatus, errorThrown) ->
        console.log("Get Results Error: #{textStatus}")
        deferred.reject(textStatus)

      deferred.promise()
  Result
