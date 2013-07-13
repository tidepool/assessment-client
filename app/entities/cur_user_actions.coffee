define [
  'backbone'
  'core'
],
(
  Backbone
  app
) ->

  Collection = Backbone.Collection.extend
    #TODO: resolve the circular dependency issue and remove window reference, use app.cfg instead
    url: "#{window.apiServerUrl}/api/v1/users/-/recommendations/actions"
  Collection

