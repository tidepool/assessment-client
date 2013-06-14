
define [
  'backbone'
], (
  Backbone
) ->

  _me = 'entities/user_personality_skinny'

  Model = Backbone.Model.extend
    defaults:
      name: null
      one_liner: null
      logo_url: null

  Model

