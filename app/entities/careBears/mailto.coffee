define [
  'backbone'
  './careBear'
], (
  Backbone
  CareBear
) ->

  _me = 'entities/careBears/mailto'

  Model = CareBear.extend

    url: 'mailto:'

    validate: (attrs, options) ->
      return "Need subject" unless attrs.subject
      return "Need body" unless attrs.body

  Model

