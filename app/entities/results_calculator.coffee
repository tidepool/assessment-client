

define [
  'jquery'
  'backbone'
  'entities/results/result'
], (
  $
  Backbone
  Result
) ->

  _me = 'entities/results_calculator'
  _maxTryCount = 2 # Total tries, from the beginning, only happens if the server errors
  _maxPollCount = 15 # Poll limit, normal behavior

  Model = Backbone.Model.extend

    #TODO: Remove and replace with enum on the result model
    STATES:
      pending: 'pending'
      error: 'error'
      done: 'done'

    urlRoot: -> "#{window.apiServerUrl}/api/v1/users/-/games/#{@get('game_id')}/results"

    initialize: ->
      @tries = 0
      @on 'sync', @onSync
      @tryTryAgain()

    tryTryAgain: ->
      @polls = 0
      @fetch()


    # ----------------------------------------------------------------------------------- Private Methods
    pollForProgress: (url) ->
#      console.log "#{_me}.pollForProgress(#{url})"
      promise = $.ajax
        type: 'GET'
        url: url
      promise.done (data, textStatus, jqXHR) =>
        console.log("Unexpected StatusCode: #{jqXHR.status}") if jqXHR.status isnt 200
        switch data.status.state
          when @STATES.pending
            # Look for progress updates at intervals
            @polls += 1
            if @polls >= _maxPollCount
              @trigger 'error', @, 'Timed out waiting for results.'
            else
              setTimeout =>
                @pollForProgress data.status.link
              , 500
          when @STATES.done then @set 'status', data.status
          when @STATES.error then @_handleServerError data
          else @trigger 'error', @, "Unexpected status #{data.status.state}"
      promise.fail (jqXHR, textStatus, errorThrown) ->
        @trigger 'error', @, textStatus, { jqXHR:jqXHR, textStatus:textStatus, errorThrown:errorThrown }


    _handleServerError: (data) ->
      @tries++
      console.log "Error on try #{@tries}"
      if @tries >= _maxTryCount
        @trigger 'error', @, data.status.message
      else
        @tryTryAgain()


  # ------------------------------------------------------------------------------ Callbacks
    onSync: (model) ->
      @pollForProgress model.attributes.status.link


  Model
