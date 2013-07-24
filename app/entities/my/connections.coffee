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
    #TODO: resolve the circular dependency issue and remove window reference, use app.cfg instead
    url: "#{window.apiServerUrl}/api/v1/users/-/connections"

    initialize: (options) -> @options = options

    parse: (resp, options) ->
      resp = @dewrap resp
      for connection in resp
        connection.user_id = @options.app.user.id
      console.log resp:resp
      resp


  Export

