
require [
  "routers/main_router"
  "underscore"
  "Backbone"
  "scripts/app_secrets_dev"
],
(
  MainRouter
  _
  Backbone
  appConfig
) ->
  "use strict"
  console.log "App Started"

  window.DEBUG = true
  DEBUG && console.log("App Started")

  window.apiServerUrl = appConfig.apiServer;

  new MainRouter appConfig
  Backbone.history.start()
