

define [
  'jquery'
  'backbone'
], (
  $
  Backbone
) ->

  _me = 'entities/results_calculator'
  _maxPollCount = 20

  Model = Backbone.Model.extend

    STATES:
      pending: 'pending'
      error: 'error'
      done: 'done'

    urlRoot: ->
      gameId = @get('game_id')
      "#{window.apiServerUrl}/api/v1/users/-/games/#{gameId}/result"

    initialize: ->
      @startCalculation()
      @on 'sync', @onSync


    # ----------------------------------------------------------------------------------- Private Methods
    pollForProgress: (url) ->
#      console.log "#{_me}.pollForProgress(#{url})"
      $.ajax
        type: 'GET'
        url: url
      .done (data, textStatus, jqXHR) =>
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
          when @STATES.done
#            console.log("Done with results")
            #TODO: use the status that the back end is returning with the fetch on the result object instead
            @set 'status', data.status
          when @STATES.error
            @trigger 'error', @, textStatus
          else
            @trigger 'error', @, "Unexpected status #{data.status.state}"
      .fail (jqXHR, textStatus, errorThrown) ->
        @trigger 'error', @, textStatus, { jqXHR:jqXHR, textStatus:textStatus, errorThrown:errorThrown }


    # ------------------------------------------------------------------------------ Callbacks
    onSync: (model) ->
      @pollForProgress model.attributes.status.link


    # ----------------------------------------------------------------------------------- Public API
    startCalculation: ->
      @attempts = 0
      @save()


  Model
