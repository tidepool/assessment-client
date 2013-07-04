

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
  _maxPollCount = 20

  Model = Backbone.Model.extend

    #TODO: Remove and replace with enum on the result model
    STATES:
      pending: 'pending'
      error: 'error'
      done: 'done'

    urlRoot: -> "#{window.apiServerUrl}/api/v1/users/-/games/#{@get('game_id')}/results"

    initialize: ->
      @attempts = 0
      @fetch()
      @on 'sync', @onSync


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
            @attempts += 1
            if @attempts >= _maxPollCount
              @trigger 'error', @, 'Timed out waiting for results.'
            else
              setTimeout =>
                @pollForProgress data.status.link
              , 500
          when @STATES.done then @set 'status', data.status
          when @STATES.error then @trigger 'error', @, data.status.message
          else @trigger 'error', @, "Unexpected status #{data.status.state}"

      promise.fail (jqXHR, textStatus, errorThrown) ->
        @trigger 'error', @, textStatus, { jqXHR:jqXHR, textStatus:textStatus, errorThrown:errorThrown }


    # ------------------------------------------------------------------------------ Callbacks
    onSync: (model) ->
      @pollForProgress model.attributes.status.link


  Model
