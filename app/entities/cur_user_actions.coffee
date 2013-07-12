define [
  'backbone'
  'core'
],
(
  Backbone
  app
) ->

  Collection = Backbone.Collection.extend
    url: "#{app.cfg.apiServer}/api/v1/users/-/recommendations/actions"

  Collection

