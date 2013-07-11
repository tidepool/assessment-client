define [
  'backbone'
  'core'
],
(
  Backbone
  app
) ->

  # A Single Game Level
  Model = Backbone.Model.extend
    urlRoot: "#{app.cfg.apiServer}/api/v1/users/-/recommendations"
    id: 'latest'

  Model

