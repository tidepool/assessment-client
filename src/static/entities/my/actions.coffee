define [
  'classes/collection'
],
(
  Collection
) ->

  Export = Collection.extend
    url: -> "#{window.apiServerUrl}/api/v1/users/-/recommendations/actions"

  Export

