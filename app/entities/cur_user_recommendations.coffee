define [
  'backbone'
  'core'
],
(
  Backbone
  app
) ->

  Model = Backbone.Model.extend
    urlRoot: "#{app.cfg.apiServer}/api/v1/users/-/recommendations"
    id: 'latest'

  Model

