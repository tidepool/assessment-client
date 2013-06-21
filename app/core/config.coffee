
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
    apiServer: '@@APISERVER'
    appSecret: '@@APPSECRET'
    appId: '@@APPID'
    fbId: '@@fbId'
    #fbSecret: '@@fbSecret'

  window.apiServerUrl = config.apiServer #TODO: eeeeeew! Encapsulate config instead

  config


