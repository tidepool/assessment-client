
define [
  'underscore'
  'scripts/app_secrets_dev'
],
(
  _
  appSecrets
) ->

  _me = 'core/config'
  config =
    appName: 'TidePool'
    debug: false
    googleAnalyticsKey: 'UA-40367760-1'

  _.extend config, appSecrets
  window.apiServerUrl = config.apiServer #TODO: eeeeeew! Encapsulate config instead

  config