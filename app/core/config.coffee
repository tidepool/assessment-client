
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
    debug: true
    googleAnalyticsKey: '@@googleAnalyticsKey'
    kissKey: '@@kissKey'
    apiServer: '@@apiServer'
    appSecret: '@@appSecret'
    appId: '@@appId'
    fbId: '@@fbId'
    #fbSecret: '@@fbSecret'

  window.apiServerUrl = config.apiServer #TODO: eeeeeew! Encapsulate config instead

  config


