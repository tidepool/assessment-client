define [
  'backbone'
  './careBear'
  'core'
], (
  Backbone
  CareBear
  app
) ->

  _me = 'entities/careBears/facebook'

  Model = CareBear.extend
    defaults:
      app_id: app.cfg.fbId
      redirect_uri: "https://alpha.tidepool.co/#{window.location.hash}"

    url: 'https://www.facebook.com/dialog/feed/'

    validate: (attrs, options) ->
      return "Need a name" unless attrs.name
      return "Need a caption" unless attrs.caption
#      return "Need a description" unless attrs.description
      return "Need a link" unless attrs.link
      return "need a picture" unless attrs.picture



  Model

