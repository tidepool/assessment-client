define [
  'routers/main_router'
],
(
  MainRouter
) ->
  _me = 'core/router'
  console.log "Parsing #{_me}"

  CoreRouter = (options) ->
    @origRouter = new MainRouter options
    @

  return CoreRouter
