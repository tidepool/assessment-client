
define [
  'underscore'
  'scripts/app_secrets_dev'
],
(
  _
  appSecrets
) ->

  _me = 'core/config'
  _defaults =
    appName: 'TidePool'
    debug: true
    googleAnalyticsKey: 'UA-40367760-1'
  console.log "Parsing #{_me}"

  config = _.extend appSecrets, _defaults

  config

