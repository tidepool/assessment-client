
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
    googleAnalyticsKey: 'UA-40367760-1'
    apiServer: '@@APISERVER'
    appSecret: '@@APPSECRET'
    appId: '@@APPID'

  window.apiServerUrl = config.apiServer #TODO: eeeeeew! Encapsulate config instead

  config