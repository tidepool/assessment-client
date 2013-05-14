
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
  AppConfig
) ->
  "use strict"
  console.log "App Started"
  options =
    definition: 3
    trigger: true

  options = _.extend(options, AppConfig)
  Backbone.history.start pushState: false
  new MainRouter(options)
