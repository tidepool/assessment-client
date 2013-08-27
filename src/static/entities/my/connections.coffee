define [
  'classes/collection'
  'entities/connection'
],
(
  Collection
  Connection
) ->

  Export = Collection.extend
    model: Connection
    url: -> "#{window.apiServerUrl}/api/v1/users/-/connections"

    initialize: (options) -> @options = options

    parse: (resp, options) ->
      resp = @dewrap resp
      # Add the user id, because we need that in each model to build the link to the auth redirect
      for connection in resp
        connection.user_id = @options.app.user.id
      resp


  Export

