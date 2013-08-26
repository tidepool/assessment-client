
define [
  'underscore'
],
(
  _
  appSecrets
) ->

  _me = 'core/config'
  config =
    appName: 'TidePool'

  window.apiServerUrl = config.apiServer #TODO: eeeeeew! Encapsulate config instead

  config


