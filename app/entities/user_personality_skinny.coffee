
define [
  'classes/model'
], (
  Model
) ->

  _me = 'entities/user_personality_skinny'

  Export = Model.extend
    defaults:
      name: null
      one_liner: null
      logo_url: null

  Export

