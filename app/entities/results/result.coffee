
define [
  'backbone'
], (
  Backbone
) ->

  _me = 'entities/results/result'

  Model = Backbone.Model.extend
    defaults:
      game_id: null
      user_id: null
      time_played: null

  Model.STATES =
    pending: 'pending'
    error: 'error'
    done: 'done'

  Model