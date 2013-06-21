define [
  'backbone'
  './careBear'
], (
  Backbone
  CareBear
) ->

  _me = 'entities/cur_user_personality'

  Model = CareBear.extend
    defaults:
      related: 'TidePoolInc'

    url: 'http://twitter.com/share'

    validate: (attrs, options) ->
      return "Need text" unless attrs.text
      return "Need url" unless attrs.url

  Model

