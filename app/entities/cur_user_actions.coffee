define [
  'classes/collection'
  'core'
],
(
  Collection
  app
) ->

  Export = Collection.extend
    #TODO: resolve the circular dependency issue and remove window reference, use app.cfg instead
    url: "#{window.apiServerUrl}/api/v1/users/-/recommendations/actions"

  Export

