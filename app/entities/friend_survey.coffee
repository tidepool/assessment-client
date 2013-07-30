define [
  'underscore'
  'classes/model'
  'core'
], (
  _
  Model
  app
) ->

  Export = Model.extend
    url: -> "#{app.cfg.apiServer}/api/v1/games/#{@attributes.game_id}/friend_survey"

    initialize: ->
      @on 'error', @onErr

    onErr: ->
      console.error "Error getting the friend survey results"

  Export


