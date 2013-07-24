
define [
  'classes/model'
], (
  Model
) ->

  _me = 'entities/results/result'

  Export = Model.extend
    defaults:
      game_id: null
      user_id: null
      time_played: null

  Export.STATES =
    pending: 'pending'
    error: 'error'
    done: 'done'

  Export